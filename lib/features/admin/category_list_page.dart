// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_state.dart';
import '../../core/firebase_service.dart';
import '../../models/category.dart';
import '../../Widgets/header.dart';
import '../../Widgets/responsive_layout.dart';
import '../../Widgets/mobile_drawer.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context) || ResponsiveLayout.isTablet(context);
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: isMobile ? MobileDrawer() : null,
      appBar: isMobile ? Header() : null,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.raleway(
                          color: Colors.amber,
                          fontSize: isMobile ? 22 : 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showCategoryDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Category', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
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

                  // Category Stream
                  Expanded(
                    child: StreamBuilder<List<CategoryModel>>(
                      stream: firebaseService.categoriesStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.amber));
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                        }

                        final categories = (snapshot.data ?? []).where((cat) {
                          return cat.name.toLowerCase().contains(_searchQuery);
                        }).toList();

                        if (categories.isEmpty) {
                          return const Center(child: Text('No categories found', style: TextStyle(color: Colors.white54)));
                        }

                        return isMobile 
                            ? _buildListView(categories, firebaseService) 
                            : _buildGridView(categories, firebaseService);
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
              'CATEGORY MANAGEMENT',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Text(
              'Add, edit, or delete store categories in real-time.',
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
          _sidebarItem(context, 'Categories', Icons.category, '/admin/categories', selected: true),
          _sidebarItem(context, 'Users', Icons.people, '/admin/users'),
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

  Widget _buildListView(List<CategoryModel> categories, FirebaseService fs) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: category.imageUrl.isNotEmpty
                  ? Image.network(category.imageUrl, width: 45, height: 45, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.category, color: Colors.amber))
                  : const Icon(Icons.category, color: Colors.amber),
            ),
            title: Text(category.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('Slug: ${category.slug}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.amber),
                  onPressed: () => _showCategoryDialog(context, category: category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, category, fs),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<CategoryModel> categories, FirebaseService fs) {
    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
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
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: category.imageUrl.isNotEmpty
                        ? Image.network(category.imageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (context, error, stackTrace) => const Icon(Icons.category, color: Colors.amber, size: 50))
                        : const Icon(Icons.category, color: Colors.amber, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Slug: ${category.slug}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    onPressed: () => _showCategoryDialog(context, category: category),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context, category, fs),
                    tooltip: 'Delete',
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, CategoryModel category, FirebaseService fs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete Category', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${category.name}"? This action cannot be undone.', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.amber)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (category.imageUrl.isNotEmpty) {
                await fs.deleteImageFromUrl(category.imageUrl);
              }
              await fs.deleteCategory(category.categoryId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category deleted successfully'), backgroundColor: Colors.green),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, {CategoryModel? category}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CategoryFormDialog(category: category),
    );
  }
}

class _CategoryFormDialog extends StatefulWidget {
  final CategoryModel? category;
  const _CategoryFormDialog({this.category});

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _slugController;

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String _existingImageUrl = '';
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _slugController = TextEditingController(text: widget.category?.slug ?? '');
    _existingImageUrl = widget.category?.imageUrl ?? '';

    _nameController.addListener(() {
      if (widget.category == null) {
        _slugController.text = _nameController.text
            .toLowerCase()
            .trim()
            .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
            .replaceAll(RegExp(r'\s+'), '-');
      }
    });
  }

  void _pickImage() {
    final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      if (input.files!.isEmpty) return;
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((loadEvent) {
        setState(() {
          _selectedImageBytes = reader.result as Uint8List;
          _selectedImageName = file.name;
        });
      });
    });
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final fs = Provider.of<FirebaseService>(context, listen: false);
    String finalImageUrl = _existingImageUrl;

    if (_selectedImageBytes != null && _selectedImageName != null) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Delete old image if updating
      if (_existingImageUrl.isNotEmpty) {
        await fs.deleteImageFromUrl(_existingImageUrl);
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$_selectedImageName';
      final uploadTask = fs.uploadCategoryImage(fileName, _selectedImageBytes!);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      final taskSnapshot = await uploadTask;
      finalImageUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });
    }

    final categoryData = CategoryModel(
      categoryId: widget.category?.categoryId ?? '',
      name: _nameController.text.trim(),
      slug: _slugController.text.trim(),
      imageUrl: finalImageUrl,
      createdAt: widget.category?.createdAt ?? DateTime.now(),
    );

    if (widget.category == null) {
      await fs.addCategory(categoryData);
    } else {
      await fs.updateCategory(categoryData);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.category == null ? 'Category added successfully' : 'Category updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.category == null;
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(isNew ? 'Add Category' : 'Edit Category', style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                TextFormField(
                  controller: _nameController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  ),
                ),
                const SizedBox(height: 20),

                // Slug Field
                TextFormField(
                  controller: _slugController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => value == null || value.isEmpty ? 'Slug is required' : null,
                  decoration: const InputDecoration(
                    labelText: 'Slug',
                    labelStyle: TextStyle(color: Colors.white70),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  ),
                ),
                const SizedBox(height: 25),

                // Image Picker / Preview Area
                Text('Category Image', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Center(
                  child: InkWell(
                    onTap: _isSaving ? null : _pickImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[800]!),
                      ),
                      child: _selectedImageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                            )
                          : (_existingImageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(_existingImageUrl, fit: BoxFit.cover),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo, color: Colors.amber, size: 30),
                                      SizedBox(height: 8),
                                      Text('Pick Image', style: TextStyle(color: Colors.white54, fontSize: 12)),
                                    ],
                                  ),
                                )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Upload Progress Indicator
                if (_isUploading) ...[
                  const Text('Uploading image...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.black,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 10),
                  Text('${(_uploadProgress * 100).toStringAsFixed(0)}% uploaded', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.amber)),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveCategory,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                )
              : Text(isNew ? 'Create' : 'Save', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
