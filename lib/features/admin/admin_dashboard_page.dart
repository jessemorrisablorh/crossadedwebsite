import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_state.dart';
import '../../Widgets/header.dart';
import '../../Widgets/footer.dart';
import '../../Widgets/responsive_layout.dart';
import '../../Widgets/mobile_drawer.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile =
        ResponsiveLayout.isMobile(context) ||
        ResponsiveLayout.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: isMobile ? MobileDrawer() : null,
      appBar: isMobile ? Header() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isMobile) ...[
              // Desktop: show the full header
              const SizedBox(height: 40),
            ],
            const SizedBox(height: 40),
            Text(
              'Admin Dashboard',
              style: GoogleFonts.raleway(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Manage your store',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _AdminCard(
                  title: 'Products',
                  icon: Icons.shopping_bag,
                  onTap: () => context.go('/admin/products'),
                ),
                _AdminCard(
                  title: 'Categories',
                  icon: Icons.category,
                  onTap: () => context.go('/admin/categories'),
                ),
                _AdminCard(
                  title: 'Users',
                  icon: Icons.people,
                  onTap: () => context.go('/admin/users'),
                ),
                _AdminCard(
                  title: 'Back to Site',
                  icon: Icons.storefront,
                  color: Colors.grey[800],
                  onTap: () => context.go('/'),
                ),
                _AdminCard(
                  title: 'Logout',
                  icon: Icons.logout,
                  color: Colors.red[900],
                  onTap: () async {
                    await Provider.of<AppState>(
                      context,
                      listen: false,
                    ).signOut();
                    if (context.mounted) context.go('/');
                  },
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _AdminCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  State<_AdminCard> createState() => _AdminCardState();
}

class _AdminCardState extends State<_AdminCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: widget.color ?? Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovering ? Colors.amber : Colors.grey[800]!,
              width: _hovering ? 2 : 1,
            ),
            boxShadow: _hovering
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.15),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 48,
                  color: _hovering ? Colors.amber : Colors.white70,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
