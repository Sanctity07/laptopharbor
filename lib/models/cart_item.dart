class CartItem {
  final String productId;
  final String name;
  final String subtitle; // short spec/variant line, e.g. "32GB RAM, 1TB SSD"
  final String imageUrl;
  final double priceAtAdd;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    this.subtitle = '',
    required this.imageUrl,
    required this.priceAtAdd,
    this.quantity = 1,
  });

  double get subtotal => priceAtAdd * quantity;

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      subtitle: map['subtitle'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      priceAtAdd: (map['priceAtAdd'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'priceAtAdd': priceAtAdd,
      'quantity': quantity,
    };
  }
}