import 'dart:convert';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final List<String> colors;
  final String? category;
  final List<String> sizes;
  final int availableStock;
  final bool isFeatured;
  final List<String> tags;
  final int views;
  final String gender; // "men" | "women" | "unisex" | "kids"

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.colors,
    this.category,
    required this.sizes,
    required this.availableStock,
    required this.isFeatured,
    required this.tags,
    required this.views,
    required this.gender,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      category: json['category'],
      sizes: List<String>.from(json['sizes'] ?? []),
      availableStock: json['availableStock'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      views: json['views'] ?? 0,
      gender: json['gender'] ?? 'unisex',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'colors': colors,
      'category': category,
      'sizes': sizes,
      'availableStock': availableStock,
      'isFeatured': isFeatured,
      'tags': tags,
      'views': views,
      'gender': gender,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    List<String>? colors,
    String? category,
    List<String>? sizes,
    int? availableStock,
    String? status,
    bool? isFeatured,
    List<String>? tags,
    int? views,
    String? gender,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      colors: colors ?? this.colors,
      category: category ?? this.category,
      sizes: sizes ?? this.sizes,
      availableStock: availableStock ?? this.availableStock,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
      views: views ?? this.views,
      gender: gender ?? this.gender,
    );
  }

  static Product fromJsonString(String jsonString) =>
      Product.fromJson(json.decode(jsonString));

  String toJsonString() => json.encode(toJson());
}
