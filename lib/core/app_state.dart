import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

/// Global application state, provided via Provider.
class AppState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isCustomerLoggedIn = false;
  bool _isAdminLoggedIn = false;
  bool _isLoadingAuth = false;
  User? _currentUser;

  bool get isCustomerLoggedIn => _isCustomerLoggedIn;
  bool get isAdminLoggedIn => _isAdminLoggedIn;
  bool get isLoadingAuth => _isLoadingAuth;
  User? get currentUser => _currentUser;

  AppState() {
    // Check initial auth state on startup
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      // Check if logged-in user is customer or admin
      _isCustomerLoggedIn = true;
      _checkAdminStatus(_currentUser!.uid);
    }
  }

  Future<void> _checkAdminStatus(String uid) async {
    try {
      final snap = await _firestore.collection('admins').doc(uid).get();
      if (snap.exists) {
        _isAdminLoggedIn = true;
        _isCustomerLoggedIn = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking admin status: $e');
    }
  }

  /// Sign in a regular customer (email/password).
  Future<bool> signInCustomer(String email, String password) async {
    _isLoadingAuth = true;
    notifyListeners();
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = cred.user;
      _isCustomerLoggedIn = true;
      _isAdminLoggedIn = false;

      // Double check if this user is actually an admin
      if (_currentUser != null) {
        final adminSnap = await _firestore
            .collection('admins')
            .doc(_currentUser!.uid)
            .get();
        if (adminSnap.exists) {
          _isAdminLoggedIn = true;
          _isCustomerLoggedIn = false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('Customer sign‑in error: $e');
      return false;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  /// Sign in an administrator. Verifies that user is in the `admins` collection.
  Future<bool> signInAdmin(String email, String password) async {
    _isLoadingAuth = true;
    notifyListeners();
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user?.uid;
      if (uid == null) return false;

      // Verify the user exists in Firestore `admins` collection.
      final snap = await _firestore.collection('users').doc(uid).get();
      if (snap.exists) {
        _currentUser = cred.user;
        _isAdminLoggedIn = true;
        _isCustomerLoggedIn = false;
        return true;
      }

      // Not an admin – sign out immediately.
      await _auth.signOut();
      return false;
    } catch (e) {
      debugPrint('Admin sign‑in error: $e');
      return false;
    } finally {
      _isLoadingAuth = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _isCustomerLoggedIn = false;
    _isAdminLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  FirebaseService get firebaseService => FirebaseService.instance;
}
