import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_state.dart';
import '../../core/firebase_service.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../Widgets/header.dart';
import '../../Widgets/responsive_layout.dart';
import '../../Widgets/mobile_drawer.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isMobile =
        ResponsiveLayout.isMobile(context) ||
        ResponsiveLayout.isTablet(context);
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
                        'Products',
                        style: GoogleFonts.raleway(
                          color: Colors.amber,
                          fontSize: isMobile ? 22 : 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showProductDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Add Product',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
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

                  // Products Stream
                  Expanded(
                    child: StreamBuilder<List<Product>>(
                      stream: firebaseService.productsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final products = (snapshot.data ?? []).where((p) {
                          return p.name.toLowerCase().contains(_searchQuery) ||
                              p.categoryName.toLowerCase().contains(
                                _searchQuery,
                              );
                        }).toList();

                        if (products.isEmpty) {
                          return const Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(color: Colors.white54),
                            ),
                          );
                        }

                        return isMobile
                            ? _buildListView(products, firebaseService)
                            : _buildGridView(products, firebaseService);
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
              'PRODUCT MANAGEMENT',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Text(
              'Manage products, track inventory, and configure sales.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.storefront, color: Colors.amber),
          label: const Text(
            'View Store',
            style: TextStyle(color: Colors.amber),
          ),
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
          _sidebarItem(
            context,
            'Dashboard',
            Icons.dashboard,
            '/admin/dashboard',
          ),
          _sidebarItem(
            context,
            'Products',
            Icons.shopping_bag,
            '/admin/products',
            selected: true,
          ),
          _sidebarItem(
            context,
            'Categories',
            Icons.category,
            '/admin/categories',
          ),
          _sidebarItem(
            context,
            'Users',
            Icons.people,
            '/admin/users',
          ),
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
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: selected ? Colors.black26 : null,
      onTap: onTap ?? () => context.go(route),
    );
  }

  Widget _buildListView(List<Product> products, FirebaseService fs) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, color: Colors.amber),
                    )
                  : const Icon(Icons.image, color: Colors.amber),
            ),
            title: Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'GHS ${product.price.toStringAsFixed(2)} | Stock: ${product.stock}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.amber),
                  onPressed: () =>
                      _showProductDialog(context, product: product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, product, fs),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<Product> products, FirebaseService fs) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
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
                    child: product.image.isNotEmpty
                        ? Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.image,
                              color: Colors.amber,
                              size: 50,
                            ),
                          )
                        : const Icon(
                            Icons.image,
                            color: Colors.amber,
                            size: 50,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Category: ${product.categoryName}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GHS ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Stock: ${product.stock}',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    onPressed: () =>
                        _showProductDialog(context, product: product),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context, product, fs),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    Product product,
    FirebaseService fs,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Product',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${product.name}"? This will also remove its associated images.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.amber)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              for (var url in product.imageUrls) {
                await fs.deleteImageFromUrl(url);
              }
              await fs.deleteProduct(product.productId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
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

  void _showProductDialog(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ProductFormDialog(product: product),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  final Product? product;
  const _ProductFormDialog({this.product});

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _salePriceController;
  late TextEditingController _stockController;

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _featured = false;

  final List<Uint8List> _selectedImagesBytes = [];
  final List<String> _selectedImagesNames = [];
  List<String> _existingImageUrls = [];

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.price.toString() : '',
    );
    _salePriceController = TextEditingController(
      text: p != null ? p.salePrice.toString() : '',
    );
    _stockController = TextEditingController(
      text: p != null ? p.stock.toString() : '0',
    );
    _selectedCategoryId = p?.categoryId;
    _selectedCategoryName = p?.categoryName;
    _featured = p?.featured ?? false;
    _existingImageUrls = p != null ? List<String>.from(p.imageUrls) : [];
  }

  // void _pickImages() {
  //   final html.FileUploadInputElement input = html.FileUploadInputElement()
  //     ..accept = 'image/*'
  //     ..multiple = true;
  //   input.click();
  //   input.onChange.listen((event) {
  //     if (input.files!.isEmpty) return;
  //     for (var file in input.files!) {
  //       final reader = html.FileReader();
  //       reader.readAsArrayBuffer(file);
  //       reader.onLoadEnd.listen((loadEvent) {
  //         setState(() {
  //           _selectedImagesBytes.add(reader.result as Uint8List);
  //           _selectedImagesNames.add(file.name);
  //         });
  //       });
  //     }
  //   });
  // }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null || _selectedCategoryName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final fs = Provider.of<FirebaseService>(context, listen: false);
    List<String> finalImageUrls = List<String>.from(_existingImageUrls);

    if (_selectedImagesBytes.isNotEmpty) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      double singleProgressStep = 1.0 / _selectedImagesBytes.length;

      for (int i = 0; i < _selectedImagesBytes.length; i++) {
        final bytes = _selectedImagesBytes[i];
        final rawName = _selectedImagesNames[i];
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$rawName';

        final uploadTask = fs.uploadProductImage(fileName, bytes);

        uploadTask.snapshotEvents.listen((event) {
          final progress = event.bytesTransferred / event.totalBytes;
          setState(() {
            _uploadProgress =
                (i * singleProgressStep) + (progress * singleProgressStep);
          });
        });

        final taskSnapshot = await uploadTask;
        final downloadUrl = await taskSnapshot.ref.getDownloadURL();
        finalImageUrls.add(downloadUrl);
      }

      setState(() {
        _isUploading = false;
      });
    }

    final productData = Product(
      productId: widget.product?.productId ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      salePrice: double.tryParse(_salePriceController.text.trim()) ?? 0.0,
      categoryId: _selectedCategoryId!,
      categoryName: _selectedCategoryName!,
      imageUrls: finalImageUrls,
      stock: int.tryParse(_stockController.text.trim()) ?? 0,
      featured: _featured,
      createdAt: widget.product?.createdAt ?? DateTime.now(),
    );

    if (widget.product == null) {
      await fs.addProduct(productData);
    } else {
      await fs.updateProduct(productData);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product == null
                ? 'Product added successfully'
                : 'Product updated successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.product == null;
    final fs = Provider.of<FirebaseService>(context, listen: false);

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        isNew ? 'Add Product' : 'Edit Product',
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                TextFormField(
                  controller: _nameController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Product name is required'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  cursorColor: Colors.white,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white70),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Row for Price & Sale Price
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Price is required'
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Price (GHS)',
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _salePriceController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Sale Price (GHS)',
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Row for Stock & Featured Checkbox
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stockController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Stock',
                          labelStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _featured,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            setState(() {
                              _featured = val ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Featured Product',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Category Dropdown from Firestore (PHASE 6 dropdown requirement)
                StreamBuilder<List<CategoryModel>>(
                  stream: fs.categoriesStream(),
                  builder: (context, catSnapshot) {
                    final categories = catSnapshot.data ?? [];
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedCategoryId,
                      hint: const Text(
                        'Select Product Category',
                        style: TextStyle(color: Colors.white70),
                      ),
                      dropdownColor: Colors.grey[900],
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.categoryId,
                          child: Text(
                            cat.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final matched = categories.firstWhere(
                          (c) => c.categoryId == val,
                        );
                        setState(() {
                          _selectedCategoryId = val;
                          _selectedCategoryName = matched.name;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Category is required' : null,
                    );
                  },
                ),
                const SizedBox(height: 25),

                // Images Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Product Images',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // TextButton.icon(
                    //   onPressed: _isSaving ? null : _pickImages,
                    //   icon: const Icon(
                    //     Icons.add_photo_alternate,
                    //     color: Colors.amber,
                    //   ),
                    //   label: const Text(
                    //     'Pick Image(s)',
                    //     style: TextStyle(color: Colors.amber),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 10),

                // Previews Grid (existing and new images)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // Existing Images from Firestore
                    ..._existingImageUrls.map((url) {
                      return Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey[800]!),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(url, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  _existingImageUrls.remove(url);
                                });
                                // Delete old image from Storage immediately
                                await fs.deleteImageFromUrl(url);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    // New Selected Images
                    ...List.generate(_selectedImagesBytes.length, (index) {
                      final bytes = _selectedImagesBytes[index];
                      return Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey[800]!),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.memory(bytes, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedImagesBytes.removeAt(index);
                                  _selectedImagesNames.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // Upload Progress Bar
                if (_isUploading) ...[
                  const Text(
                    'Uploading image(s)...',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.black,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(_uploadProgress * 100).toStringAsFixed(0)}% uploaded',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
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
          onPressed: _isSaving ? null : _saveProduct,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  isNew ? 'Create' : 'Save',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
