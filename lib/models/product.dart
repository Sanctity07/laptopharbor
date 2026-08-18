class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice; // set when the product is on sale
  final bool isNew;
  final Map<String, dynamic> specs;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    this.isNew = false,
    required this.specs,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
  });

  bool get onSale => originalPrice != null && originalPrice! > price;

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      originalPrice: map['originalPrice'] != null ? (map['originalPrice'] as num).toDouble() : null,
      isNew: map['isNew'] ?? false,
      specs: Map<String, dynamic>.from(map['specs'] ?? {}),
      images: List<String>.from(map['images'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      stock: map['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'isNew': isNew,
      'specs': specs,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
    };
  }
}