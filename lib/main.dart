// ignore_for_file: depend_on_referenced_packages

import 'package:cross_faded_web/Pages/about_page.dart';
import 'package:cross_faded_web/Pages/account_page.dart';
import 'package:cross_faded_web/Pages/cart_page.dart';
import 'package:cross_faded_web/Pages/categories_page.dart';
import 'package:cross_faded_web/Pages/contact_page.dart';
import 'package:cross_faded_web/Pages/homepage.dart';
import 'package:cross_faded_web/Pages/order_successful_page.dart';
import 'package:cross_faded_web/Pages/orderspage.dart';
import 'package:cross_faded_web/Pages/product_details_page.dart';
import 'package:cross_faded_web/Pages/products_by_category.dart';
import 'package:cross_faded_web/Pages/shoppage.dart';
import 'package:cross_faded_web/features/admin/admin_dashboard_page.dart';
import 'package:cross_faded_web/features/admin/product_list_page.dart';
import 'package:cross_faded_web/features/admin/category_list_page.dart';
import 'package:cross_faded_web/features/admin/admin_login_page.dart';
import 'package:cross_faded_web/features/admin/user_list_page.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/core/app_state.dart';
import 'package:cross_faded_web/core/firebase_service.dart' as svc;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyARuRLdEEcN4IgFGiTCfnwxNRiwrbohVXU",
      authDomain: "blessed-care-int.firebaseapp.com",
      projectId: "blessed-care-int",
      storageBucket: "blessed-care-int.appspot.com",
      messagingSenderId: "279408409414",
      appId: "1:279408409414:web:656fc3c5a51b5530c38347",
      measurementId: "G-PQ11SQWHGZ",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider.value(value: svc.FirebaseService.instance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);

    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: appState,
      redirect: (context, state) {
        final isAdmin = appState.isAdminLoggedIn;
        final location = state.uri.path;

        // Redirect from base /admin to /admin/dashboard
        if (location == '/admin') {
          return isAdmin ? '/admin/dashboard' : '/admin/login';
        }

        // Protected Admin Routes Guard
        if (location.startsWith('/admin/')) {
          if (location != '/admin/login' && !isAdmin) {
            return '/admin/login';
          }
          if (location == '/admin/login' && isAdmin) {
            return '/admin/dashboard';
          }
        }
        return null;
      },
      routes: [
        // Storefront Customer Routes
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Homepage()),
        ),
        GoRoute(
          path: '/aboutus',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AboutPage()),
        ),
        GoRoute(
          path: '/shop',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Shoppage()),
        ),
        GoRoute(
          path: '/contactus',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ContactPage()),
        ),
        GoRoute(
          path: '/cart',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CartPage()),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CategoriesPage()),
        ),
        GoRoute(
          path: '/account',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AccountPage()),
        ),
        GoRoute(
          path: '/orders',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Orderspage()),
        ),
        GoRoute(
          path: '/success',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: OrderSuccessfulPage()),
        ),
        GoRoute(
          path: '/products-by-category',
          pageBuilder: (context, state) {
            final categoryName = state.extra as String;
            return NoTransitionPage(
              child: ProductsByCategory(categoryname: categoryName),
            );
          },
        ),
        GoRoute(
          path: '/product-details',
          pageBuilder: (context, state) {
            final productid = state.extra as String;
            return NoTransitionPage(child: ProductDetailsPage(id: productid));
          },
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: AuthenticationWidget()),
            ),
          ),
        ),

        // Admin Protected Routes
        GoRoute(
          path: '/admin/login',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AdminLoginPage()),
        ),
        GoRoute(
          path: '/admin/dashboard',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AdminDashboardPage()),
        ),
        GoRoute(
          path: '/admin/products',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProductListPage()),
        ),
        GoRoute(
          path: '/admin/categories',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CategoryListPage()),
        ),
        GoRoute(
          path: '/admin/users',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: UserListPage()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CrossFaded',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
