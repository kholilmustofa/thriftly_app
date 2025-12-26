import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk Product
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final String sellerId;
  final String sellerName;
  final String? condition; // 'new', 'like-new', 'good', 'fair'
  final String? size; // 'S', 'M', 'L', 'XL', etc
  final String? brand;
  final bool isAvailable;
  final int views;
  final int likes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.sellerId,
    required this.sellerName,
    this.condition,
    this.size,
    this.brand,
    this.isAvailable = true,
    this.views = 0,
    this.likes = 0,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create ProductModel from Firestore document
  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      condition: data['condition'],
      size: data['size'],
      brand: data['brand'],
      isAvailable: data['isAvailable'] ?? true,
      views: data['views'] ?? 0,
      likes: data['likes'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert ProductModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      // Don't include 'id' in document data - it's the document ID
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'condition': condition,
      'size': size,
      'brand': brand,
      'isAvailable': isAvailable,
      'views': views,
      'likes': likes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Create a copy with modified fields
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    String? sellerId,
    String? sellerName,
    String? condition,
    String? size,
    String? brand,
    bool? isAvailable,
    int? views,
    int? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      condition: condition ?? this.condition,
      size: size ?? this.size,
      brand: brand ?? this.brand,
      isAvailable: isAvailable ?? this.isAvailable,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get formatted price
  String get formattedPrice {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  /// Get primary image (first image or placeholder)
  String get primaryImage {
    if (images.isNotEmpty) {
      return images.first;
    }
    return 'https://via.placeholder.com/400x400?text=No+Image';
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, category: $category)';
  }
}

/// Categories untuk produk
class ProductCategories {
  static const String pakaian = 'Pakaian';
  static const String sepatu = 'Sepatu';
  static const String tas = 'Tas';
  static const String aksesoris = 'Aksesoris';
  static const String elektronik = 'Elektronik';
  static const String buku = 'Buku';
  static const String lainnya = 'Lainnya';

  static List<String> get all => [
    pakaian,
    sepatu,
    tas,
    aksesoris,
    elektronik,
    buku,
    lainnya,
  ];
}

/// Kondisi produk
class ProductConditions {
  static const String brandNew = 'Baru';
  static const String likeNew = 'Seperti Baru';
  static const String good = 'Baik';
  static const String fair = 'Layak';

  static List<String> get all => [brandNew, likeNew, good, fair];
}
