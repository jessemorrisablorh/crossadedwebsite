import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productId;
  final String name;
  final String description;
  final double price;
  final double salePrice;
  final String categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final int stock;
  final bool featured;
  final DateTime createdAt;

  const Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.salePrice,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrls,
    required this.stock,
    required this.featured,
    required this.createdAt,
  });

  // Backwards compatibility fields/getters
  String get id => productId;
  String get image => imageUrls.isNotEmpty ? imageUrls[0] : '';
  String get category => categoryName;

  factory Product.fromMap(Map<String, dynamic> data, String docId) {
    DateTime parsedDate;
    final dynamic rawCreated = data['createdAt'];
    if (rawCreated is Timestamp) {
      parsedDate = rawCreated.toDate();
    } else if (rawCreated is String) {
      parsedDate = DateTime.tryParse(rawCreated) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    // Handle imageUrls from various formats (list, string, missing)
    List<String> parsedUrls = [];
    final dynamic urls = data['imageUrls'];
    if (urls is List) {
      parsedUrls = List<String>.from(urls.map((e) => e.toString()));
    } else if (data['image'] is String && (data['image'] as String).isNotEmpty) {
      parsedUrls = [data['image'] as String];
    }

    return Product(
      productId: docId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      salePrice: (data['salePrice'] ?? 0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? data['category'] ?? '',
      imageUrls: parsedUrls,
      stock: data['stock'] ?? 0,
      featured: data['featured'] ?? false,
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'salePrice': salePrice,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrls': imageUrls,
      'image': image, // preserve single image for backward compatibility in firestore
      'category': categoryName, // preserve category for backward compatibility
      'stock': stock,
      'featured': featured,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
