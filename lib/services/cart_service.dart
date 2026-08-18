import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _cartRef(String uid) =>
      _db.collection('users').doc(uid).collection('cart');

  Future<List<CartItem>> fetchCart(String uid) async {
    final snap = await _cartRef(uid).get();
    return snap.docs
        .map((d) => CartItem.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addOrUpdateItem(String uid, CartItem item) {
    return _cartRef(uid).doc(item.productId).set(item.toMap());
  }

  Future<void> removeItem(String uid, String productId) {
    return _cartRef(uid).doc(productId).delete();
  }

  Future<void> clearCart(String uid) async {
    final snap = await _cartRef(uid).get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }
}
