// ============================================================
// MODEL: product_model.dart
// Bertanggung jawab menyimpan struktur data Produk
// ============================================================
 
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isFavorite;
  final List<String> tags;
  final String seller;
 
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
    this.isFavorite = false,
    this.tags = const [],
    required this.seller,
  });
 
  // Hitung persentase diskon
  double get discountPercent {
    if (originalPrice <= 0 || price >= originalPrice) return 0;
    return ((originalPrice - price) / originalPrice * 100).roundToDouble();
  }
 
  bool get hasDiscount => discountPercent > 0;
 
  // Salin objek dengan perubahan tertentu
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    int? stock,
    bool? isFavorite,
    List<String>? tags,
    String? seller,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      seller: seller ?? this.seller,
    );
  }
 
  // Konversi ke Map (untuk penyimpanan lokal)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'isFavorite': isFavorite,
      'tags': tags,
      'seller': seller,
    };
  }
 
  // Buat objek dari Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      originalPrice: map['originalPrice'].toDouble(),
      imageUrl: map['imageUrl'],
      category: map['category'],
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      stock: map['stock'] ?? 0,
      isFavorite: map['isFavorite'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      seller: map['seller'],
    );
  }
}
 