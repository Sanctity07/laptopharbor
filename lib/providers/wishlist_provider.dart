import 'package:flutter/material.dart';
import '../services/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _service = WishlistService();
  Set<String> productIds = {};

  Future<void> loadWishlist(String uid) async {
    productIds = (await _service.fetchWishlistProductIds(uid)).toSet();
    notifyListeners();
  }

  bool isWishlisted(String productId) => productIds.contains(productId);

  Future<void> toggle(String uid, String productId) async {
    if (productIds.contains(productId)) {
      productIds.remove(productId);
      await _service.removeFromWishlist(uid, productId);
    } else {
      productIds.add(productId);
      await _service.addToWishlist(uid, productId);
    }
    notifyListeners();
  }
}
