import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;
    final isAdminRoute = location.startsWith('/admin');
    final appState = Provider.of<AppState>(context, listen: false);

    if (isAdminRoute) {
      return Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Admin Menu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white),
              title: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.white),
              title: const Text(
                'Products',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/products');
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.white),
              title: const Text(
                'Categories',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/categories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text(
                'Users',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.white),
              title: const Text(
                'Storefront',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                Navigator.pop(context);
                await appState.signOut();
                if (context.mounted) context.go('/');
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // DrawerHeader(
            //   decoration: BoxDecoration(color: Colors.black),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         'CROSSFADED',
            //         style: GoogleFonts.anton(
            //           color: Colors.amber,
            //           fontSize: 30,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CROSSFADED',
                    style: GoogleFonts.anton(
                      color: Colors.amber,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: Text(
                  'Home',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ListTile(
                leading: const Icon(Icons.store, color: Colors.white),
                title: Text(
                  'Our Shop',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/shop');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ListTile(
                leading: const Icon(Icons.contact_mail, color: Colors.white),
                title: Text(
                  'Contact Us',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/contactus');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: Text(
                  'My Account',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  if (FirebaseAuth.instance.currentUser == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MobileAuthenticationWidget();
                      },
                    );
                  } else {
                    context.go('/account');
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
