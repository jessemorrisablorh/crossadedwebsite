import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_state.dart';
import '../../Widgets/header.dart';
import '../../Widgets/responsive_layout.dart';
import '../../Widgets/mobile_drawer.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context) || ResponsiveLayout.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: isMobile ? const MobileDrawer() : null,
      appBar: isMobile ? const Header() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar on Desktop
          if (!isMobile) _buildSidebar(context),

          // Main Area
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 15.0 : 40.0,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile) ...[
                    const SizedBox(height: 20),
                    _buildDesktopHeader(context),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 30),
                  ],
                  Text(
                    'Users',
                    style: GoogleFonts.raleway(
                      color: Colors.amber,
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search users by name or email...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: Colors.amber),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim().toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 25),

                  // Users Stream
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.amber));
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                        }

                        final docs = snapshot.data?.docs ?? [];
                        final users = docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>? ?? {};
                          final email = (data['email'] ?? '').toString().toLowerCase();
                          final firstName = (data['firstname'] ?? '').toString().toLowerCase();
                          final lastName = (data['lastname'] ?? '').toString().toLowerCase();
                          final fullName = '$firstName $lastName';
                          return email.contains(_searchQuery) ||
                              firstName.contains(_searchQuery) ||
                              lastName.contains(_searchQuery) ||
                              fullName.contains(_searchQuery);
                        }).toList();

                        if (users.isEmpty) {
                          return const Center(child: Text('No users found', style: TextStyle(color: Colors.white54)));
                        }

                        return isMobile 
                            ? _buildListView(users) 
                            : _buildGridView(users);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'USER MANAGEMENT',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Text(
              'View and edit user details in real-time.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.storefront, color: Colors.amber),
          label: const Text('View Store', style: TextStyle(color: Colors.amber)),
        ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[900],
      child: Column(
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            child: const Text(
              'Dashboard Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          _sidebarItem(context, 'Dashboard', Icons.dashboard, '/admin/dashboard'),
          _sidebarItem(context, 'Products', Icons.shopping_bag, '/admin/products'),
          _sidebarItem(context, 'Categories', Icons.category, '/admin/categories'),
          _sidebarItem(context, 'Users', Icons.people, '/admin/users', selected: true),
          const Spacer(),
          const Divider(color: Colors.white24),
          _sidebarItem(
            context,
            'Logout',
            Icons.logout,
            '/',
            color: Colors.redAccent,
            onTap: () async {
              await Provider.of<AppState>(context, listen: false).signOut();
              if (context.mounted) context.go('/');
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    BuildContext context,
    String title,
    IconData icon,
    String route, {
    bool selected = false,
    Color? color,
    VoidCallback? onTap,
  }) {
    final textColor = color ?? (selected ? Colors.amber : Colors.white70);
    final iconColor = color ?? (selected ? Colors.amber : Colors.white54);

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      tileColor: selected ? Colors.black26 : null,
      onTap: onTap ?? () => context.go(route),
    );
  }

  Widget _buildListView(List<DocumentSnapshot> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final userDoc = users[index];
        final data = userDoc.data() as Map<String, dynamic>? ?? {};
        final email = data['email'] ?? '';
        final firstName = data['firstname'] ?? '';
        final lastName = data['lastname'] ?? '';
        final role = data['role'] ?? 'customer';
        final phone = data['phone'] ?? '';

        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(Icons.person, color: Colors.black),
            ),
            title: Text(
              '$firstName $lastName'.trim().isEmpty ? 'No Name' : '$firstName $lastName',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: role == 'admin' ? Colors.red.withValues(alpha: 0.2) : Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        role.toString().toUpperCase(),
                        style: TextStyle(
                          color: role == 'admin' ? Colors.red : Colors.amber,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (phone.toString().isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(phone, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.amber),
                  onPressed: () => _showUserDialog(context, userDoc),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, userDoc),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<DocumentSnapshot> users) {
    return GridView.builder(
      itemCount: users.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final userDoc = users[index];
        final data = userDoc.data() as Map<String, dynamic>? ?? {};
        final email = data['email'] ?? '';
        final firstName = data['firstname'] ?? '';
        final lastName = data['lastname'] ?? '';
        final role = data['role'] ?? 'customer';
        final phone = data['phone'] ?? '';
        final address = data['address'] ?? '';
        final city = data['city'] ?? '';
        final region = data['region'] ?? '';

        final displayName = '$firstName $lastName'.trim().isEmpty ? 'No Name' : '$firstName $lastName';

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[800]!),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: role == 'admin' ? Colors.red.withValues(alpha: 0.2) : Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      role.toString().toUpperCase(),
                      style: TextStyle(
                        color: role == 'admin' ? Colors.red : Colors.amber,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(email, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              if (phone.toString().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Phone: $phone', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
              if (address.toString().isNotEmpty || city.toString().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Address: $address, $city ($region)'.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showUserDialog(context, userDoc),
                    icon: const Icon(Icons.edit, size: 16, color: Colors.amber),
                    label: const Text('Edit', style: TextStyle(color: Colors.amber)),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _confirmDelete(context, userDoc),
                    icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                    label: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUserDialog(BuildContext context, DocumentSnapshot userDoc) {
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
                style: GoogleFonts.raleway(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 500,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Email (Read-only)
                        TextFormField(
                          initialValue: email,
                          readOnly: true,
                          style: const TextStyle(color: Colors.white54),
                          decoration: const InputDecoration(
                            labelText: 'Email Address (Read-only)',
                            labelStyle: TextStyle(color: Colors.white38),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // First Name
                        TextFormField(
                          controller: firstNameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(color: Colors.amber),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Last Name
                        TextFormField(
                          controller: lastNameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(color: Colors.amber),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Phone
                        TextFormField(
                          controller: phoneController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(color: Colors.amber),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Address
                        TextFormField(
                          controller: addressController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(color: Colors.amber),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // City
                        TextFormField(
                          controller: cityController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'City',
                            labelStyle: TextStyle(color: Colors.amber),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Region
                        TextFormField(
                          controller: regionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Region',
                            labelStyle: TextStyle(color: Colors.amber),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Role Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: selectedRole,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            labelStyle: TextStyle(color: Colors.amber),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'customer', child: Text('Customer')),
                            DropdownMenuItem(value: 'admin', child: Text('Admin')),
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
                  child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await FirebaseFirestore.instance.collection('users').doc(userDoc.id).update({
                        'firstname': firstNameController.text.trim(),
                        'lastname': lastNameController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'address': addressController.text.trim(),
                        'city': cityController.text.trim(),
                        'region': regionController.text.trim(),
                        'role': selectedRole,
                      });

                      if (selectedRole == 'admin') {
                        await FirebaseFirestore.instance.collection('admins').doc(userDoc.id).set({
                          'uid': userDoc.id,
                          'email': email,
                        });
                      } else {
                        await FirebaseFirestore.instance.collection('admins').doc(userDoc.id).delete();
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User details updated successfully'), backgroundColor: Colors.green),
                        );
                      }
                    }
                  },
                  child: const Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, DocumentSnapshot userDoc) {
    final data = userDoc.data() as Map<String, dynamic>? ?? {};
    final email = data['email'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Confirm Deletion', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete the user "$email"? This action cannot be undone.', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').doc(userDoc.id).delete();
                await FirebaseFirestore.instance.collection('admins').doc(userDoc.id).delete();

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User deleted successfully'), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
