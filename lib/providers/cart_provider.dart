import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();
  List<CartItem> items = [];

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get tax => subtotal * 0.075;
  double get shipping => items.isEmpty ? 0 : 10.0;
  double get total => subtotal + tax + shipping;

  Future<void> loadCart(String uid) async {
    items = await _service.fetchCart(uid);
    notifyListeners();
  }

  Future<void> addItem(String uid, CartItem item) async {
    final existingIndex = items.indexWhere((i) => i.productId == item.productId);
    if (existingIndex >= 0) {
      items[existingIndex].quantity += item.quantity;
    } else {
      items.add(item);
    }
    await _service.addOrUpdateItem(uid, items.firstWhere((i) => i.productId == item.productId));
    notifyListeners();
  }

  Future<void> removeItem(String uid, String productId) async {
    items.removeWhere((i) => i.productId == productId);
    await _service.removeItem(uid, productId);
    notifyListeners();
  }

  Future<void> clearCart(String uid) async {
    items.clear();
    await _service.clearCart(uid);
    notifyListeners();
  }
}
