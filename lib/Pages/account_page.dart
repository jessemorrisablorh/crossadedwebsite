// ignore_for_file: use_build_context_synchronously

import 'dart:io' as io;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/loading_widget.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cross_faded_web/core/firebase_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopAccountPage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return const DesktopAccountPage();
        } else {
          return const MobileAccountPage();
        }
      },
    );
  }
}

class DesktopAccountPage extends StatefulWidget {
  const DesktopAccountPage({super.key});

  @override
  State<DesktopAccountPage> createState() => _DesktopAccountPageState();
}

class _DesktopAccountPageState extends State<DesktopAccountPage> {
  String selectedValue = 'categories';
  String status = "pending";
  String selectedCategory = "";
  int currentPage = 0;
  final int itemsPerPage = 12; // 12 products per page
  final TextEditingController searchController = TextEditingController();

  List searchResults = [];
  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return LoadingWidget();
        }
        if (asyncSnapshot.data?["role"] == "admin") {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DesktopHeader(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 80.0,
                      right: 80.0,
                      top: 50.0,
                      bottom: 50.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = "categories";
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.grid_goldenratio,
                                          color: selectedValue == "categories"
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Categories",
                                          style: GoogleFonts.poppins(
                                            color: selectedValue == "categories"
                                                ? Colors.amber
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = "products";
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.grid_4x4_outlined,
                                          color: selectedValue == "products"
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Products",
                                          style: GoogleFonts.poppins(
                                            color: selectedValue == "products"
                                                ? Colors.amber
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = "sliders";
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.view_carousel,
                                          color: selectedValue == "sliders"
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Sliders",
                                          style: GoogleFonts.poppins(
                                            color: selectedValue == "sliders"
                                                ? Colors.amber
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = "orders";
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_basket,
                                          color: selectedValue == "orders"
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Orders",
                                          style: GoogleFonts.poppins(
                                            color: selectedValue == "orders"
                                                ? Colors.amber
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = "users";
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.group,
                                          color: selectedValue == "users"
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Users",
                                          style: GoogleFonts.poppins(
                                            color: selectedValue == "users"
                                                ? Colors.amber
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = "profile";
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: selectedValue == "profile"
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Profile",
                                          style: GoogleFonts.poppins(
                                            color: selectedValue == "profile"
                                                ? Colors.amber
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = "mobile-app-version";
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone_android,
                                          color:
                                              selectedValue ==
                                                  "mobile-app-version"
                                              ? Colors.amber
                                              : Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Mobile App Version",
                                          style: GoogleFonts.poppins(
                                            color:
                                                selectedValue ==
                                                    "mobile-app-version"
                                                ? Colors.amber
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () async {
                                      await FirebaseAuth.instance
                                          .signOut()
                                          .then((onValue) {
                                            context.go('/');
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.exit_to_app_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          "Sign Out",
                                          style: GoogleFonts.poppins(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 6,
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: selectedValue == "categories"
                                ? categoriesList(width, height)
                                : selectedValue == "products"
                                ? productsList(width, height)
                                : selectedValue == "sliders"
                                ? slidersList(width, height)
                                : selectedValue == "orders"
                                ? ordersList(width, height)
                                : selectedValue == "profile"
                                ? profilePage(width, height)
                                : selectedValue == "mobile-app-version"
                                ? mobileAppVersionPage(width, height)
                                : selectedValue == "sign-out"
                                ? categoriesList(width, height)
                                : selectedValue == "users"
                                ? usersList(width, height)
                                : categoriesList(width, height),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DesktopFooter(),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              children: [
                DesktopHeader(),
                Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 80.0,
                      right: 80.0,
                      top: 80.0,
                      bottom: 80.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Account",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Manage your account settings and preferences",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 80.0,
                            right: 80.0,
                            top: 50.0,
                          ),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, asyncSnapshot) {
                              if (!asyncSnapshot.hasData) {
                                return Container();
                              }
                              final userData = asyncSnapshot.data!.data()!;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(50.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Billing Information",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Firstname:   ",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),

                                                Text(
                                                  userData['firstname'] ??
                                                      'User',
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Lastname:   ",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  userData['lastname'] ??
                                                      'User',
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Email:   ",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  userData['email'] ?? 'User',
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Phone:   ",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  userData['phone'] ?? 'User',
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Address:   ",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  userData['address'] ?? 'User',
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Region:   ",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  userData['region'] ?? 'User',
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "City:   ",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.amber,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  userData['city'] ?? 'User',
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(50.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditBillingInformation();
                                                  },
                                                ); // Navigate to edit account information page
                                              },
                                              child: Text(
                                                "Edit Account Information ",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return ChangePasswordDialog();
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "Change password",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            InkWell(
                                              onTap: () async {
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                context.go('/');
                                              },
                                              child: Text(
                                                "Sign Out",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.red,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DesktopFooter(),
              ],
            ),
          ),
          floatingActionButton: floatingButtons(
            height: height,
            width: width,
            context: context,
          ),
        );
      },
    );
  }
}

Widget profilePage(double width, double height) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        );
      }
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Center(
          child: Text(
            "Profile not found",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      final userData = snapshot.data!.data() as Map<String, dynamic>;

      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Profile Details",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            _profileRow("Firstname:", userData['firstname'] ?? ''),
            _profileRow("Lastname:", userData['lastname'] ?? ''),
            _profileRow("Email:", userData['email'] ?? ''),
            _profileRow("Phone:", userData['phone'] ?? ''),
            _profileRow("Address:", userData['address'] ?? ''),
            _profileRow("Region:", userData['region'] ?? ''),
            _profileRow("City:", userData['city'] ?? ''),
            _profileRow(
              "Role:",
              (userData['role'] ?? 'admin').toString().toUpperCase(),
              isHighlight: true,
            ),
            const SizedBox(height: 35),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EditBillingInformation(),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.black),
                label: Text(
                  "Edit Profile Info",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _profileRow(String label, String value, {bool isHighlight = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.amber,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? 'Not set' : value,
            style: GoogleFonts.raleway(
              color: isHighlight ? Colors.amber : Colors.white,
              fontSize: 13,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget mobileAppVersionPage(double width, double height) {
  final versionController = TextEditingController();
  final buildNumberController = TextEditingController();
  final updateUrlController = TextEditingController();
  bool forceUpdate = false;
  bool isInitialized = false;

  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection("configs")
        .doc("app_version")
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        );
      }

      if (snapshot.hasData && snapshot.data!.exists && !isInitialized) {
        final data = snapshot.data!.data() as Map<String, dynamic>;
        versionController.text = data['version'] ?? '1.0.0';
        buildNumberController.text = data['buildNumber'] ?? '1';
        updateUrlController.text = data['updateUrl'] ?? '';
        forceUpdate = data['forceUpdate'] ?? false;
        isInitialized = true;
      }

      return StatefulBuilder(
        builder: (context, setStateState) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mobile App Version Management",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Configure the latest app version for update prompts on iOS/Android.",
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: versionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Latest Version Code (e.g., 1.0.0)",
                    labelStyle: TextStyle(color: Colors.amber),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: buildNumberController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Latest Build Number (e.g., 1)",
                    labelStyle: TextStyle(color: Colors.amber),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: updateUrlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "App Store / Play Store Update URL",
                    labelStyle: TextStyle(color: Colors.amber),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Force Update Required",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Switch(
                      value: forceUpdate,
                      activeThumbColor: Colors.amber,
                      onChanged: (val) {
                        setStateState(() {
                          forceUpdate = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("configs")
                          .doc("app_version")
                          .set({
                            "version": versionController.text.trim(),
                            "buildNumber": buildNumberController.text.trim(),
                            "updateUrl": updateUrlController.text.trim(),
                            "forceUpdate": forceUpdate,
                            "lastUpdated": FieldValue.serverTimestamp(),
                          }, SetOptions(merge: true));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "App version configurations updated successfully",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Text(
                      "Save Configuration",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class MobileAccountPage extends StatefulWidget {
  const MobileAccountPage({super.key});

  @override
  State<MobileAccountPage> createState() => _MobileAccountPageState();
}

class _MobileAccountPageState extends State<MobileAccountPage> {
  String selectedCategory = "";
  int currentPage = 0;
  final int itemsPerPage = 12; // 12 products per page
  final TextEditingController searchController = TextEditingController();

  List searchResults = [];
  bool showSuggestions = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: MobileDrawer(),
      appBar: Header(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Account",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Manage your settings and preferences",
                style: GoogleFonts.raleway(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 30),

              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                  final userData =
                      asyncSnapshot.data!.data() as Map<String, dynamic>? ?? {};

                  return Column(
                    children: [
                      // Billing Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Billing Information",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(color: Colors.white24, height: 25),
                            _billingItem(
                              "First name",
                              userData['firstname'] ?? '',
                            ),
                            _billingItem(
                              "Last name",
                              userData['lastname'] ?? '',
                            ),
                            _billingItem("Email", userData['email'] ?? ''),
                            _billingItem("Phone", userData['phone'] ?? ''),
                            _billingItem("Address", userData['address'] ?? ''),
                            _billingItem("Region", userData['region'] ?? ''),
                            _billingItem("City", userData['city'] ?? ''),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Actions Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const EditBillingInformation(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                              ),
                              child: Text(
                                "Edit Account Info",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const ChangePasswordDialog(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                              ),
                              child: Text(
                                "Change Password",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                if (context.mounted) context.go('/');
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent),
                              ),
                              child: Text(
                                "Sign Out",
                                style: GoogleFonts.poppins(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              const Footer(),
            ],
          ),
        ),
      ),
      floatingActionButton: floatingButtons(
        height: height,
        width: width,
        context: context,
      ),
    );
  }

  Widget _billingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? 'Not set' : value,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

Widget categoriesList(double width, double height) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('categories')
        .where('name', isNotEqualTo: 'Uncategorized')
        .snapshots(),
    builder: (context, asyncSnapshot) {
      if (asyncSnapshot.hasError) {
        return Center(child: Text('Error: ${asyncSnapshot.error}'));
      }
      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
        return LoadingWidget();
      }
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => _showAddCategoryDialog(context),
                  child: Container(
                    height: 0.060 * height,
                    width: 0.13 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Add Category",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 25),
            // Create GridView for Categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
              ),
              itemCount: asyncSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final category = asyncSnapshot.data!.docs[index];
                return _adminCategoryCard(context, category, width, height);
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget slidersList(double width, double height) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('sliders').snapshots(),
    builder: (context, asyncSnapshot) {
      if (asyncSnapshot.hasError) {
        return Center(child: Text('Error: ${asyncSnapshot.error}'));
      }
      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
        return LoadingWidget();
      }
      final docs = asyncSnapshot.data?.docs ?? [];
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Homepage Sliders",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => _showAddSlideDialog(context),
                  child: Container(
                    height: 0.060 * height,
                    width: 0.13 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Add Slide",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 25),
            if (docs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    "No slides added yet. Click 'Add Slide' to upload one.",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final slide = docs[index];
                  return _adminSliderCard(context, slide, width, height);
                },
              ),
          ],
        ),
      );
    },
  );
}

Widget _adminSliderCard(
  BuildContext context,
  DocumentSnapshot doc,
  double width,
  double height,
) {
  final slide = doc.data() as Map<String, dynamic>? ?? {};
  final String image = slide['image'] ?? '';

  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white10),
    ),
    child: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: image.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: Colors.white24,
                        size: 50,
                      ),
                    ),
                  )
                : const Icon(Icons.image, color: Colors.white24, size: 50),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.amber, size: 20),
                onPressed: () => _showEditSlideDialog(context, doc),
                tooltip: "Edit slide image",
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                onPressed: () => _confirmDeleteSlide(context, doc),
                tooltip: "Delete slide",
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showAddSlideDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String? uploadedImageUrl;
  bool isUploading = false;
  String? uploadError;

  Future<void> pickAndUploadImage(StateSetter setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final fileName = file.name;

      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = await io.File(file.path!).readAsBytes();
      }

      if (fileBytes == null) {
        setDialogState(() {
          uploadError = "Could not read file bytes. Please try another image.";
        });
        return;
      }

      setDialogState(() {
        isUploading = true;
        uploadError = null;
      });

      final task = FirebaseService.instance.uploadSliderImage(
        '${DateTime.now().millisecondsSinceEpoch}_$fileName',
        fileBytes,
      );

      final snapshot = await task;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setDialogState(() {
        uploadedImageUrl = downloadUrl;
        isUploading = false;
      });
    } catch (e) {
      setDialogState(() {
        isUploading = false;
        uploadError = "Upload failed: $e";
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Add New Slide',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: uploadError != null
                              ? Colors.redAccent
                              : Colors.white24,
                        ),
                      ),
                      child: isUploading
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.amber),
                                SizedBox(height: 10),
                                Text(
                                  "Uploading to Storage...",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            )
                          : uploadedImageUrl != null &&
                                  uploadedImageUrl!.isNotEmpty
                          ? Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      uploadedImageUrl!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                    ),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        pickAndUploadImage(setDialogState),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () => pickAndUploadImage(setDialogState),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Click to upload slide image",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (uploadError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        uploadError!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (uploadedImageUrl == null || uploadedImageUrl!.isEmpty) {
                    setDialogState(() {
                      uploadError = "Please upload a slide image first";
                    });
                    return;
                  }

                  final docRef = FirebaseFirestore.instance
                      .collection('sliders')
                      .doc();
                  await docRef.set({
                    'id': docRef.id,
                    'image': uploadedImageUrl,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Slide added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showEditSlideDialog(
  BuildContext context,
  DocumentSnapshot slideDoc,
) {
  final data = slideDoc.data() as Map<String, dynamic>? ?? {};
  final formKey = GlobalKey<FormState>();

  String? uploadedImageUrl = data['image'] ?? '';
  bool isUploading = false;
  String? uploadError;

  Future<void> pickAndUploadImage(StateSetter setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final fileName = file.name;

      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = await io.File(file.path!).readAsBytes();
      }

      if (fileBytes == null) {
        setDialogState(() {
          uploadError = "Could not read file bytes. Please try another image.";
        });
        return;
      }

      setDialogState(() {
        isUploading = true;
        uploadError = null;
      });

      final task = FirebaseService.instance.uploadSliderImage(
        '${DateTime.now().millisecondsSinceEpoch}_$fileName',
        fileBytes,
      );

      final snapshot = await task;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setDialogState(() {
        uploadedImageUrl = downloadUrl;
        isUploading = false;
      });
    } catch (e) {
      setDialogState(() {
        isUploading = false;
        uploadError = "Upload failed: $e";
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Edit Slide Image',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: uploadError != null
                              ? Colors.redAccent
                              : Colors.white24,
                        ),
                      ),
                      child: isUploading
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.amber),
                                SizedBox(height: 10),
                                Text(
                                  "Uploading new image...",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            )
                          : uploadedImageUrl != null &&
                                  uploadedImageUrl!.isNotEmpty
                          ? Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      uploadedImageUrl!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                    ),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        pickAndUploadImage(setDialogState),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () => pickAndUploadImage(setDialogState),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Click to upload slide image",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (uploadError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        uploadError!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (uploadedImageUrl == null || uploadedImageUrl!.isEmpty) {
                    setDialogState(() {
                      uploadError = "Please upload a slide image first";
                    });
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection('sliders')
                      .doc(slideDoc.id)
                      .update({
                    'image': uploadedImageUrl,
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Slide updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _confirmDeleteSlide(
  BuildContext context,
  DocumentSnapshot slideDoc,
) {
  final data = slideDoc.data() as Map<String, dynamic>? ?? {};
  final imageUrl = data['image'] ?? '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this slide? This will remove the image from the homepage slideshow.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              // Delete document from Firestore
              await FirebaseFirestore.instance
                  .collection('sliders')
                  .doc(slideDoc.id)
                  .delete();

              // Delete image from storage
              if (imageUrl.isNotEmpty) {
                await FirebaseService.instance.deleteImageFromUrl(imageUrl);
              }

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Slide deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget productsList(double width, double height) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('products')
        .where('name', isNotEqualTo: 'Uncategorized')
        .snapshots(),
    builder: (context, asyncSnapshot) {
      if (asyncSnapshot.hasError) {
        return Center(child: Text('Error: ${asyncSnapshot.error}'));
      }
      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
        return LoadingWidget();
      }
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Products",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => _showAddProductDialog(context),
                  child: Container(
                    height: 0.060 * height,
                    width: 0.13 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Add Product",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 25),
            // Create GridView for Products
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: asyncSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final product = asyncSnapshot.data!.docs[index];
                return _adminProductCard(context, product, width, height);
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget ordersList(double width, double height) {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  String selectedStatusFilter = "pending";

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Orders",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Status filter buttons
                Row(
                  children: [
                    _statusFilterButton(
                      "pending",
                      Colors.amber,
                      selectedStatusFilter,
                      (val) {
                        setState(() {
                          selectedStatusFilter = val;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _statusFilterButton(
                      "completed",
                      Colors.green,
                      selectedStatusFilter,
                      (val) {
                        setState(() {
                          selectedStatusFilter = val;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _statusFilterButton(
                      "cancelled",
                      Colors.redAccent,
                      selectedStatusFilter,
                      (val) {
                        setState(() {
                          selectedStatusFilter = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 25),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .where("status", isEqualTo: selectedStatusFilter)
                  .orderBy("date_created", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Text(
                        "No $selectedStatusFilter orders found.",
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                final orders = snapshot.data!.docs;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.white24, height: 25),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final day = order["day_created"];
                    final month = order["month_created"];
                    final year = order["year_created"];
                    final totalAmt = (order["total"] ?? 0.0).toDouble();
                    final orderId = order["id"] ?? '';
                    final currentStatus = order["status"] ?? 'pending';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order ID: ${orderId.substring(0, orderId.length > 8 ? 8 : orderId.length)}...",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "$day - $month - $year",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _orderInfoRow("Status", currentStatus),
                                _orderInfoRow(
                                  "Total Amount",
                                  "GHS ${formatCurrency.format(totalAmt)}",
                                ),
                                _orderInfoRow(
                                  "Payment",
                                  order["payment_method_title"] ?? '',
                                ),
                              ],
                            ),
                            // Status update dropdown
                            DropdownButton<String>(
                              dropdownColor: Colors.grey[900],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              value: currentStatus,
                              items: const [
                                DropdownMenuItem(
                                  value: 'pending',
                                  child: Text('Pending'),
                                ),
                                DropdownMenuItem(
                                  value: 'completed',
                                  child: Text('Completed'),
                                ),
                                DropdownMenuItem(
                                  value: 'cancelled',
                                  child: Text('Cancelled'),
                                ),
                              ],
                              onChanged: (newStatus) async {
                                if (newStatus != null &&
                                    newStatus != currentStatus) {
                                  await FirebaseFirestore.instance
                                      .collection("orders")
                                      .doc(order.id)
                                      .update({"status": newStatus});
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Order status updated to $newStatus",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _viewCartDetails(
                              context,
                              order["cartitems"] ?? [],
                            ),
                            icon: const Icon(
                              Icons.list_alt,
                              color: Colors.grey,
                              size: 18,
                            ),
                            label: Text(
                              "View Items",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _statusFilterButton(
  String label,
  Color color,
  String currentFilter,
  ValueChanged<String> onTap,
) {
  final isSelected = currentFilter == label;
  return InkWell(
    onTap: () => onTap(label),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
        border: Border.all(color: isSelected ? color : Colors.white30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          color: isSelected ? color : Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget usersList(double width, double height) {
  int currentPage = 0;
  final int itemsPerPage = 5;
  String selectedUserFilter = "clients";

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }

            final allUsers = snapshot.hasData ? snapshot.data!.docs : [];
            final users = allUsers.where((u) {
              final data = u.data() as Map<String, dynamic>?;
              if (data == null) return false;
              final role = data['role'] ?? 'customer';
              if (selectedUserFilter == 'administrators') {
                return role == 'admin';
              } else {
                return role != 'admin';
              }
            }).toList();

            final totalPages = users.isEmpty ? 0 : (users.length / itemsPerPage).ceil();
            final startIndex = currentPage * itemsPerPage;
            final endIndex = (startIndex + itemsPerPage) > users.length
                ? users.length
                : startIndex + itemsPerPage;
            final currentUsers = users.isEmpty ? [] : users.sublist(startIndex, endIndex);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedUserFilter == "administrators"
                          ? "Registered Administrators"
                          : "Registered Customers",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () => _showAddAdminDialog(context),
                      icon: const Icon(Icons.add_moderator),
                      label: const Text(
                        "Add Admin",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _statusFilterButton(
                      "clients",
                      Colors.amber,
                      selectedUserFilter,
                      (val) {
                        setState(() {
                          selectedUserFilter = val;
                          currentPage = 0;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    _statusFilterButton(
                      "administrators",
                      Colors.amber,
                      selectedUserFilter,
                      (val) {
                        setState(() {
                          selectedUserFilter = val;
                          currentPage = 0;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 20),
                if (users.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Text(
                        selectedUserFilter == "administrators"
                            ? "No administrators found."
                            : "No customers found.",
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentUsers.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.white24, height: 25),
                    itemBuilder: (context, index) {
                      final userDoc = currentUsers[index];
                      final user = userDoc.data() as Map<String, dynamic>? ?? {};
                      final email = user["email"] ?? "No Email";
                      final phone = user["phone"] ?? "No Phone";
                      final address = user["address"] ?? "No Address";
                      final city = user["city"] ?? "";
                      final region = user["region"] ?? "";

                      final firstName = user["firstname"] ?? "";
                      final lastName = user["lastname"] ?? "";
                      final username = user["username"] ?? "";
                      final displayName = '$firstName $lastName'.trim().isNotEmpty
                          ? '$firstName $lastName'
                          : (username.toString().isNotEmpty
                                ? username
                                : "No Name");

                      final day = user["daycreated"] ?? user["day_created"] ?? "";
                      final month =
                          user["monthcreated"] ?? user["month_created"] ?? "";
                      final year =
                          user["yearcreated"] ?? user["year_created"] ?? "";
                      final dateStr =
                          (day.toString().isNotEmpty &&
                              month.toString().isNotEmpty &&
                              year.toString().isNotEmpty)
                          ? "Registered: $day - $month - $year"
                          : "";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name: $displayName",
                                style: GoogleFonts.poppins(
                                  color: Colors.amber,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (dateStr.isNotEmpty)
                                Text(
                                  dateStr,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email: $email",
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        _showEditUserDialog(context, userDoc),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        _confirmDeleteUser(context, userDoc),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Phone: $phone",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Address: $address${city.toString().isNotEmpty ? ', $city' : ''}${region.toString().isNotEmpty ? ' ($region)' : ''}",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (totalPages > 1) ...[
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: currentPage > 0
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "Page ${currentPage + 1} of $totalPages",
                          style: GoogleFonts.aldrich(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          onPressed: currentPage < totalPages - 1
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            );
          },
        ),
      );
    },
  );
}

void _showEditUserDialog(BuildContext context, DocumentSnapshot userDoc) {
  final data = userDoc.data() as Map<String, dynamic>? ?? {};
  final String email = data['email'] ?? '';
  final String initialFirstName = data['firstname'] ?? '';
  final String initialLastName = data['lastname'] ?? '';
  final String initialPhone = data['phone'] ?? '';
  final String initialAddress = data['address'] ?? '';
  final String initialCity = data['city'] ?? '';
  final String initialRegion = data['region'] ?? '';
  String selectedRole = data['role'] ?? 'customer';

  final firstNameController = TextEditingController(text: initialFirstName);
  final lastNameController = TextEditingController(text: initialLastName);
  final phoneController = TextEditingController(text: initialPhone);
  final addressController = TextEditingController(text: initialAddress);
  final cityController = TextEditingController(text: initialCity);
  final regionController = TextEditingController(text: initialRegion);

  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Edit User Details',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: email,
                        readOnly: true,
                        style: const TextStyle(color: Colors.white54),
                        decoration: const InputDecoration(
                          labelText: 'Email Address (Read-only)',
                          labelStyle: TextStyle(color: Colors.white38),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white12),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: firstNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: lastNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: phoneController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: addressController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: cityController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'City',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: regionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Region',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        dropdownColor: Colors.grey[900],
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'customer',
                            child: Text('Customer'),
                          ),
                          DropdownMenuItem(
                            value: 'admin',
                            child: Text('Admin'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedRole = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userDoc.id)
                        .update({
                          'firstname': firstNameController.text.trim(),
                          'lastname': lastNameController.text.trim(),
                          'phone': phoneController.text.trim(),
                          'address': addressController.text.trim(),
                          'city': cityController.text.trim(),
                          'region': regionController.text.trim(),
                          'role': selectedRole,
                        });

                    if (selectedRole == 'admin') {
                      await FirebaseFirestore.instance
                          .collection('admins')
                          .doc(userDoc.id)
                          .set({'uid': userDoc.id, 'email': email});
                    } else {
                      await FirebaseFirestore.instance
                          .collection('admins')
                          .doc(userDoc.id)
                          .delete();
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User details updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showAddAdminDialog(BuildContext context) {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final regionController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? errorMessage;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Add New Admin Account',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (errorMessage != null) ...[
                        Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                      ],
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: firstNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: lastNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: phoneController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: addressController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: cityController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'City',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: regionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Region',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CircularProgressIndicator(color: Colors.amber),
                )
              else ...[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      setDialogState(() {
                        isLoading = true;
                        errorMessage = null;
                      });

                      firebase_core.FirebaseApp? tempApp;
                      try {
                        final email = emailController.text.trim();
                        final password = passwordController.text;
                        final firstName = firstNameController.text.trim();
                        final lastName = lastNameController.text.trim();
                        final phone = phoneController.text.trim();
                        final address = addressController.text.trim();
                        final city = cityController.text.trim();
                        final region = regionController.text.trim();

                        final tempAppName = 'TempApp_${DateTime.now().millisecondsSinceEpoch}';
                        tempApp = await firebase_core.Firebase.initializeApp(
                          name: tempAppName,
                          options: firebase_core.Firebase.app().options,
                        );

                        final authInstance = FirebaseAuth.instanceFor(app: tempApp);
                        final userCred = await authInstance.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        final uid = userCred.user!.uid;

                        // Create user in Firestore
                        await FirebaseFirestore.instance.collection('users').doc(uid).set({
                          'uid': uid,
                          'email': email,
                          'role': 'admin',
                          'firstname': firstName,
                          'lastname': lastName,
                          'phone': phone,
                          'address': address,
                          'city': city,
                          'region': region,
                          'daycreated': DateTime.now().day.toString(),
                          'monthcreated': DateTime.now().month.toString(),
                          'yearcreated': DateTime.now().year.toString(),
                        });

                        // Create admin reference
                        await FirebaseFirestore.instance.collection('admins').doc(uid).set({
                          'uid': uid,
                          'email': email,
                        });

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Admin created successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() {
                          isLoading = false;
                          errorMessage = e.toString().replaceFirst('FirebaseException: ', '');
                        });
                      } finally {
                        if (tempApp != null) {
                          await tempApp.delete();
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      );
    },
  );
}

void _confirmDeleteUser(BuildContext context, DocumentSnapshot userDoc) {
  final data = userDoc.data() as Map<String, dynamic>? ?? {};
  final email = data['email'] ?? '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the user "$email"? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userDoc.id)
                  .delete();
              await FirebaseFirestore.instance
                  .collection('admins')
                  .doc(userDoc.id)
                  .delete();

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _orderInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

void _viewCartDetails(BuildContext context, List<dynamic> items) {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        color: Colors.grey[900],
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Items",
              style: GoogleFonts.raleway(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24, height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.white12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final name = item["productname"] ?? '';
                  final image = item["productimage"] ?? '';
                  final qty = item["quantity"] ?? 1;
                  final price = (item["price"] ?? 0.0).toDouble();

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: image.isNotEmpty
                        ? Image.network(
                            image,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, color: Colors.white30),
                    title: Text(
                      name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Qty: $qty - GHS ${formatCurrency.format(price)}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _adminCategoryCard(
  BuildContext context,
  DocumentSnapshot doc,
  double width,
  double height,
) {
  final category = doc.data() as Map<String, dynamic>? ?? {};
  final String name = category['name'] ?? '';
  final String image = category['image'] ?? '';

  return Container(
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: image.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: Colors.white24,
                        size: 50,
                      ),
                    ),
                  )
                : const Icon(Icons.image, color: Colors.white24, size: 50),
          ),
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber, size: 20),
              onPressed: () => _showEditCategoryDialog(context, doc),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
              onPressed: () => _confirmDeleteCategory(context, doc),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

void _showAddCategoryDialog(BuildContext context) {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? uploadedImageUrl;
  bool isUploading = false;
  String? uploadError;

  Future<void> pickAndUploadImage(StateSetter setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final fileName = file.name;

      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = await io.File(file.path!).readAsBytes();
      }

      if (fileBytes == null) {
        setDialogState(() {
          uploadError = "Could not read file bytes. Please try another image.";
        });
        return;
      }

      setDialogState(() {
        isUploading = true;
        uploadError = null;
      });

      final task = FirebaseService.instance.uploadCategoryImage(
        '${DateTime.now().millisecondsSinceEpoch}_$fileName',
        fileBytes,
      );

      final snapshot = await task;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setDialogState(() {
        uploadedImageUrl = downloadUrl;
        isUploading = false;
      });
    } catch (e) {
      setDialogState(() {
        isUploading = false;
        uploadError = "Upload failed: $e";
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Add New Category',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                        labelStyle: TextStyle(color: Colors.amber),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter category name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: uploadError != null
                              ? Colors.redAccent
                              : Colors.white24,
                        ),
                      ),
                      child: isUploading
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.amber),
                                SizedBox(height: 10),
                                Text(
                                  "Uploading to Storage...",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            )
                          : uploadedImageUrl != null &&
                                uploadedImageUrl!.isNotEmpty
                          ? Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      uploadedImageUrl!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                    ),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        pickAndUploadImage(setDialogState),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () => pickAndUploadImage(setDialogState),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Click to upload category image",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (uploadError != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        uploadError!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (uploadedImageUrl == null || uploadedImageUrl!.isEmpty) {
                      setDialogState(() {
                        uploadError = "Please upload a category image first";
                      });
                      return;
                    }
                    final name = nameController.text.trim();
                    final slug = name.toLowerCase().replaceAll(' ', '-');

                    final docRef = FirebaseFirestore.instance
                        .collection('categories')
                        .doc();
                    await docRef.set({
                      'id': docRef.id,
                      'categoryId': docRef.id,
                      'name': name,
                      'slug': slug,
                      'image': uploadedImageUrl,
                      'imageUrl': uploadedImageUrl,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showEditCategoryDialog(
  BuildContext context,
  DocumentSnapshot categoryDoc,
) {
  final data = categoryDoc.data() as Map<String, dynamic>? ?? {};
  final nameController = TextEditingController(text: data['name'] ?? '');
  final formKey = GlobalKey<FormState>();

  String? uploadedImageUrl = data['image'] ?? data['imageUrl'] ?? '';
  bool isUploading = false;
  String? uploadError;

  Future<void> pickAndUploadImage(StateSetter setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final fileName = file.name;

      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = await io.File(file.path!).readAsBytes();
      }

      if (fileBytes == null) {
        setDialogState(() {
          uploadError = "Could not read file bytes. Please try another image.";
        });
        return;
      }

      setDialogState(() {
        isUploading = true;
        uploadError = null;
      });

      final task = FirebaseService.instance.uploadCategoryImage(
        '${DateTime.now().millisecondsSinceEpoch}_$fileName',
        fileBytes,
      );

      final snapshot = await task;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setDialogState(() {
        uploadedImageUrl = downloadUrl;
        isUploading = false;
      });
    } catch (e) {
      setDialogState(() {
        isUploading = false;
        uploadError = "Upload failed: $e";
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Edit Category Details',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                        labelStyle: TextStyle(color: Colors.amber),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter category name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: uploadError != null
                              ? Colors.redAccent
                              : Colors.white24,
                        ),
                      ),
                      child: isUploading
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.amber),
                                SizedBox(height: 10),
                                Text(
                                  "Uploading to Storage...",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            )
                          : uploadedImageUrl != null &&
                                uploadedImageUrl!.isNotEmpty
                          ? Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      uploadedImageUrl!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                    ),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    onPressed: () =>
                                        pickAndUploadImage(setDialogState),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () => pickAndUploadImage(setDialogState),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Click to upload category image",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (uploadError != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        uploadError!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (uploadedImageUrl == null || uploadedImageUrl!.isEmpty) {
                      setDialogState(() {
                        uploadError = "Please upload a category image first";
                      });
                      return;
                    }
                    final name = nameController.text.trim();
                    final slug = name.toLowerCase().replaceAll(' ', '-');

                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(categoryDoc.id)
                        .update({
                          'name': name,
                          'slug': slug,
                          'image': uploadedImageUrl,
                          'imageUrl': uploadedImageUrl,
                        });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _confirmDeleteCategory(
  BuildContext context,
  DocumentSnapshot categoryDoc,
) {
  final data = categoryDoc.data() as Map<String, dynamic>? ?? {};
  final name = data['name'] ?? '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the category "$name"? This will not delete the products within it.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('categories')
                  .doc(categoryDoc.id)
                  .delete();

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _adminProductCard(
  BuildContext context,
  DocumentSnapshot doc,
  double width,
  double height,
) {
  final product = doc.data() as Map<String, dynamic>? ?? {};
  final String name = product['name'] ?? '';
  final String image = product['image'] ?? '';
  final double price = (product['price'] ?? 0.0).toDouble();
  final int stock = product['stock'] ?? 0;
  final String categoryName =
      product['categoryName'] ?? product['category'] ?? '';

  final formatCurrency = NumberFormat.currency(symbol: " ");

  return Container(
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: image.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: Colors.white24,
                        size: 50,
                      ),
                    ),
                  )
                : const Icon(Icons.image, color: Colors.white24, size: 50),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "GHS ${formatCurrency.format(price)}",
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Stock: $stock | $categoryName",
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
              onPressed: () => _showEditProductDialog(context, doc),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
              onPressed: () => _confirmDeleteProduct(context, doc),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

void _showAddProductDialog(BuildContext context) {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  String? selectedCategoryId;
  String? selectedCategoryName;

  String? uploadedImageUrl;
  bool isUploading = false;
  String? uploadError;

  final formKey = GlobalKey<FormState>();

  Future<void> pickAndUploadImage(StateSetter setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final fileName = file.name;

      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = await io.File(file.path!).readAsBytes();
      }

      if (fileBytes == null) {
        setDialogState(() {
          uploadError = "Could not read file bytes. Please try another image.";
        });
        return;
      }

      setDialogState(() {
        isUploading = true;
        uploadError = null;
      });

      final task = FirebaseService.instance.uploadProductImage(
        '${DateTime.now().millisecondsSinceEpoch}_$fileName',
        fileBytes,
      );

      final snapshot = await task;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setDialogState(() {
        uploadedImageUrl = downloadUrl;
        isUploading = false;
      });
    } catch (e) {
      setDialogState(() {
        isUploading = false;
        uploadError = "Upload failed: $e";
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Add New Product',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter product name'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: priceController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Price (GHS)',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) =>
                            value == null || double.tryParse(value) == null
                            ? 'Enter valid price'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      // Image Upload Area instead of imageurl
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: uploadError != null
                                ? Colors.redAccent
                                : Colors.white24,
                          ),
                        ),
                        child: isUploading
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.amber,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Uploading to Storage...",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            : uploadedImageUrl != null &&
                                  uploadedImageUrl!.isNotEmpty
                            ? Stack(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        uploadedImageUrl!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black54,
                                      ),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      onPressed: () =>
                                          pickAndUploadImage(setDialogState),
                                    ),
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () => pickAndUploadImage(setDialogState),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colors.amber,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Click to upload product image",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      if (uploadError != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          uploadError!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 15),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('categories')
                            .get(),
                        builder: (context, catSnapshot) {
                          if (!catSnapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            );
                          }
                          final categories = catSnapshot.data!.docs;
                          return DropdownButtonFormField<String>(
                            dropdownColor: Colors.grey[900],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              labelStyle: TextStyle(color: Colors.amber),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white30),
                              ),
                            ),
                            initialValue: selectedCategoryId,
                            items: categories.map((cat) {
                              final catData =
                                  cat.data() as Map<String, dynamic>? ?? {};
                              final catName = catData['name'] ?? 'No Name';
                              return DropdownMenuItem<String>(
                                value: cat.id,
                                child: Text(catName),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                final selectedDoc = categories.firstWhere(
                                  (element) => element.id == val,
                                );
                                final selectedDocData =
                                    selectedDoc.data()
                                        as Map<String, dynamic>? ??
                                    {};
                                setDialogState(() {
                                  selectedCategoryId = val;
                                  selectedCategoryName =
                                      selectedDocData['name'] ?? '';
                                });
                              }
                            },
                            validator: (value) =>
                                value == null ? 'Select a category' : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (uploadedImageUrl == null || uploadedImageUrl!.isEmpty) {
                      setDialogState(() {
                        uploadError = "Please upload a product image first";
                      });
                      return;
                    }

                    final price = double.parse(priceController.text.trim());
                    final name = nameController.text.trim();
                    final description = descriptionController.text.trim();

                    final docRef = FirebaseFirestore.instance
                        .collection('products')
                        .doc();
                    await docRef.set({
                      'id': docRef.id,
                      'productId': docRef.id,
                      'name': name,
                      'description': description,
                      'price': price,
                      'salePrice': 0.0,
                      'stock': 100,
                      'categoryId': selectedCategoryId,
                      'categoryName': selectedCategoryName,
                      'category': selectedCategoryName,
                      'image': uploadedImageUrl,
                      'imageUrls': [uploadedImageUrl!],
                      'featured': false,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showEditProductDialog(BuildContext context, DocumentSnapshot productDoc) {
  final data = productDoc.data() as Map<String, dynamic>? ?? {};
  final nameController = TextEditingController(text: data['name'] ?? '');
  final descriptionController = TextEditingController(
    text: data['description'] ?? '',
  );
  final priceController = TextEditingController(
    text: (data['price'] ?? 0.0).toString(),
  );
  final salePriceController = TextEditingController(
    text: (data['salePrice'] ?? 0.0).toString(),
  );
  final stockController = TextEditingController(
    text: (data['stock'] ?? 0).toString(),
  );

  bool featured = data['featured'] ?? false;
  String? selectedCategoryId = data['categoryId'];
  String? selectedCategoryName = data['categoryName'] ?? data['category'];

  String? uploadedImageUrl = data['image'] ?? '';
  bool isUploading = false;
  String? uploadError;

  final formKey = GlobalKey<FormState>();

  Future<void> pickAndUploadImage(StateSetter setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final fileName = file.name;

      Uint8List? fileBytes = file.bytes;
      if (fileBytes == null && file.path != null) {
        fileBytes = await io.File(file.path!).readAsBytes();
      }

      if (fileBytes == null) {
        setDialogState(() {
          uploadError = "Could not read file bytes. Please try another image.";
        });
        return;
      }

      setDialogState(() {
        isUploading = true;
        uploadError = null;
      });

      final task = FirebaseService.instance.uploadProductImage(
        '${DateTime.now().millisecondsSinceEpoch}_$fileName',
        fileBytes,
      );

      final snapshot = await task;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setDialogState(() {
        uploadedImageUrl = downloadUrl;
        isUploading = false;
      });
    } catch (e) {
      setDialogState(() {
        isUploading = false;
        uploadError = "Upload failed: $e";
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Edit Product Details',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter product name'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: priceController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Price (GHS)',
                                labelStyle: TextStyle(color: Colors.amber),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) =>
                                  value == null ||
                                      double.tryParse(value) == null
                                  ? 'Enter valid price'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              controller: salePriceController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Sale Price (GHS)',
                                labelStyle: TextStyle(color: Colors.amber),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: stockController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Stock Quantity',
                          labelStyle: TextStyle(color: Colors.amber),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || int.tryParse(value) == null
                            ? 'Enter valid stock'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      // Image Upload Area instead of imageurl
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: uploadError != null
                                ? Colors.redAccent
                                : Colors.white24,
                          ),
                        ),
                        child: isUploading
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.amber,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Uploading to Storage...",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            : uploadedImageUrl != null &&
                                  uploadedImageUrl!.isNotEmpty
                            ? Stack(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        uploadedImageUrl!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black54,
                                      ),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      onPressed: () =>
                                          pickAndUploadImage(setDialogState),
                                    ),
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () => pickAndUploadImage(setDialogState),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colors.amber,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Click to upload product image",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      if (uploadError != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          uploadError!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 15),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('categories')
                            .get(),
                        builder: (context, catSnapshot) {
                          if (!catSnapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            );
                          }
                          final categories = catSnapshot.data!.docs;
                          return DropdownButtonFormField<String>(
                            dropdownColor: Colors.grey[900],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              labelStyle: TextStyle(color: Colors.amber),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white30),
                              ),
                            ),
                            initialValue: selectedCategoryId,
                            items: categories.map((cat) {
                              final catData =
                                  cat.data() as Map<String, dynamic>? ?? {};
                              final catName = catData['name'] ?? 'No Name';
                              return DropdownMenuItem<String>(
                                value: cat.id,
                                child: Text(catName),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                final selectedDoc = categories.firstWhere(
                                  (element) => element.id == val,
                                );
                                final selectedDocData =
                                    selectedDoc.data()
                                        as Map<String, dynamic>? ??
                                    {};
                                setDialogState(() {
                                  selectedCategoryId = val;
                                  selectedCategoryName =
                                      selectedDocData['name'] ?? '';
                                });
                              }
                            },
                            validator: (value) =>
                                value == null ? 'Select a category' : null,
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Featured Product",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Switch(
                            value: featured,
                            activeThumbColor: Colors.amber,
                            onChanged: (val) {
                              setDialogState(() {
                                featured = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    if (uploadedImageUrl == null || uploadedImageUrl!.isEmpty) {
                      setDialogState(() {
                        uploadError = "Please upload a product image first";
                      });
                      return;
                    }

                    final price = double.parse(priceController.text.trim());
                    final salePrice =
                        double.tryParse(salePriceController.text.trim()) ?? 0.0;
                    final stock = int.parse(stockController.text.trim());
                    final name = nameController.text.trim();
                    final description = descriptionController.text.trim();

                    await FirebaseFirestore.instance
                        .collection('products')
                        .doc(productDoc.id)
                        .update({
                          'name': name,
                          'description': description,
                          'price': price,
                          'salePrice': salePrice,
                          'stock': stock,
                          'categoryId': selectedCategoryId,
                          'categoryName': selectedCategoryName,
                          'category': selectedCategoryName,
                          'image': uploadedImageUrl,
                          'imageUrls': [uploadedImageUrl!],
                          'featured': featured,
                        });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _confirmDeleteProduct(BuildContext context, DocumentSnapshot productDoc) {
  final data = productDoc.data() as Map<String, dynamic>? ?? {};
  final name = data['name'] ?? '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the product "$name"? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(productDoc.id)
                  .delete();

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
