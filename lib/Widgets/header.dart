import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'responsive_layout.dart';

/// A convenience wrapper that chooses the appropriate header implementation
/// based on screen size. It mirrors the usage pattern in the rest of the app
/// where `Header(scaffoldKey: ...)` is used.
class Header extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const Header({this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isMobile(context) ||
        ResponsiveLayout.isTablet(context)) {
      // MobileHeader expects a scaffoldKey to open the drawer.
      return MobileHeader(scaffoldKey: scaffoldKey);
    }
    // DesktopHeader does not need a scaffoldKey.
    return const DesktopHeader();
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

/// Desktop version of the site header (already existed in the project).
class DesktopHeader extends StatelessWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 0.13 * height,
      width: width,
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side navigation links (Home, Shop, Contact)
            Row(
              children: [
                _navLink(context, 'Home', '/'),
                const SizedBox(width: 20),
                _navLink(context, 'Our shop', '/shop'),
                const SizedBox(width: 20),
                _navLink(context, 'Contact us', '/contactus'),
              ],
            ),
            // Center logo
            InkWell(
              onTap: () => context.go('/'),
              child: Text(
                'CROSSFADED',
                style: GoogleFonts.anton(
                  color: Colors.amber,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Right side account / cart icons
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AuthenticationWidget();
                        },
                      );
                    } else {
                      context.go('/account');
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Account', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _navLink(BuildContext context, String label, String route) {
    return InkWell(
      onTap: () => context.go(route),
      child: Text(
        label,
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Mobile version – uses a drawer controlled by the scaffoldKey.
class MobileHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const MobileHeader({this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      height: 0.13 * height,
      width: width,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  if (scaffoldKey != null) {
                    scaffoldKey!.currentState?.openEndDrawer();
                  } else {
                    Scaffold.of(context).openEndDrawer();
                  }
                },
              ),
            ),
            InkWell(
              onTap: () => context.go('/'),
              child: Text(
                'CROSSFADED',
                style: GoogleFonts.anton(
                  color: Colors.amber,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            user == null
                ? IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return MobileAuthenticationWidget();
                          },
                        );
                      } else {
                        context.go('/cart');
                      }
                    },
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("cart")
                        .where("uid", isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      int itemCount = 0;
                      if (snapshot.hasData) {
                        for (var doc in snapshot.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>?;
                          if (data != null) {
                            itemCount += ((data['quantity'] ?? 1) as num)
                                .toInt();
                          }
                        }
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: () => context.go('/cart'),
                          ),
                          if (itemCount > 0)
                            Positioned(
                              right: 5,
                              top: 5,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$itemCount',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
