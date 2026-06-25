import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart';

/// A service wrapper around Cloud Firestore and Firebase Storage for e-commerce operations.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ---------------------------------------------------------------------
  // Products CRUD
  // ---------------------------------------------------------------------
  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  Future<void> addProduct(Product product) async {
    final docRef = _productsCollection.doc();
    final data = product.toMap();
    data['productId'] = docRef.id;
    await docRef.set(data);
  }

  Future<void> updateProduct(Product product) async {
    await _productsCollection.doc(product.productId).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _productsCollection.doc(productId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchProducts() =>
      _productsCollection.snapshots();

  Stream<List<Product>> productsStream() {
    return watchProducts().map((querySnap) {
      return querySnap.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ---------------------------------------------------------------------
  // Categories CRUD
  // ---------------------------------------------------------------------
  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('categories');

  Future<void> addCategory(CategoryModel category) async {
    final docRef = _categoriesCollection.doc();
    final data = category.toMap();
    data['categoryId'] = docRef.id;
    await docRef.set(data);
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoriesCollection.doc(category.categoryId).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoriesCollection.doc(categoryId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCategories() =>
      _categoriesCollection.snapshots();

  Stream<List<CategoryModel>> categoriesStream() {
    return watchCategories().map((querySnap) {
      return querySnap.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ---------------------------------------------------------------------
  // Firebase Storage Helpers
  // ---------------------------------------------------------------------
  
  /// Starts an upload task for a product image. Returns the UploadTask so progress can be monitored.
  UploadTask uploadProductImage(String fileName, Uint8List fileBytes) {
    final ref = _storage.ref().child('products/$fileName');
    return ref.putData(fileBytes, SettableMetadata(contentType: 'image/jpeg'));
  }

  /// Starts an upload task for a category image. Returns the UploadTask so progress can be monitored.
  UploadTask uploadCategoryImage(String fileName, Uint8List fileBytes) {
    final ref = _storage.ref().child('categories/$fileName');
    return ref.putData(fileBytes, SettableMetadata(contentType: 'image/jpeg'));
  }

  /// Starts an upload task for a slider image. Returns the UploadTask so progress can be monitored.
  UploadTask uploadSliderImage(String fileName, Uint8List fileBytes) {
    final ref = _storage.ref().child('sliders/$fileName');
    return ref.putData(fileBytes, SettableMetadata(contentType: 'image/jpeg'));
  }

  /// Deletes a file in Firebase Storage by its download URL.
  Future<void> deleteImageFromUrl(String url) async {
    if (url.isEmpty || !url.contains('firebasestorage.googleapis.com')) return;
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting image from storage: $e');
    }
  }
}
