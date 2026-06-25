import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryId;
  final String name;
  final String slug;
  final String imageUrl;
  final DateTime createdAt;

  const CategoryModel({
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.createdAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> data, String docId) {
    DateTime parsedDate;
    final dynamic rawCreated = data['createdAt'];
    if (rawCreated is Timestamp) {
      parsedDate = rawCreated.toDate();
    } else if (rawCreated is String) {
      parsedDate = DateTime.tryParse(rawCreated) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return CategoryModel(
      categoryId: docId,
      name: data['name'] ?? '',
      slug: data['slug'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'id': categoryId,
      'name': name,
      'slug': slug,
      'imageUrl': imageUrl,
      'image': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
