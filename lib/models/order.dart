import 'cart_item.dart';

enum OrderStatus { placed, processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final double tax;
  final double shipping;
  final OrderStatus status;
  final String shippingAddress;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.tax,
    required this.shipping,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      shipping: (map['shipping'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.placed,
      ),
      shippingAddress: map['shippingAddress'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'tax': tax,
      'shipping': shipping,
      'status': status.name,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
