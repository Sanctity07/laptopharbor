import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();
  List<CartItem> items = [];
  bool isLoading = false;

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get tax => subtotal * 0.075;
  double get shipping => items.isEmpty ? 0 : 10.0;
  double get total => subtotal + tax + shipping;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadCart(String uid) async {
    isLoading = true;
    notifyListeners();
    try {
      items = await _service.fetchCart(uid);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String uid, CartItem item) async {
    final existingIndex =
        items.indexWhere((i) => i.productId == item.productId);
    if (existingIndex >= 0) {
      items[existingIndex].quantity += item.quantity;
      await _service.addOrUpdateItem(uid, items[existingIndex]);
    } else {
      items.add(item);
      await _service.addOrUpdateItem(uid, item);
    }
    notifyListeners();
  }

  Future<void> updateItem(String uid, CartItem item) async {
    final index = items.indexWhere((i) => i.productId == item.productId);
    if (index >= 0) {
      items[index] = item;
      await _service.addOrUpdateItem(uid, item);
      notifyListeners();
    }
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

  void clearLocal() {
    items.clear();
    notifyListeners();
  }
}
