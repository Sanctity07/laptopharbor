import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _wishlistRef(String uid) =>
      _db.collection('users').doc(uid).collection('wishlist');

  Future<List<String>> fetchWishlistProductIds(String uid) async {
    final snap = await _wishlistRef(uid).get();
    return snap.docs.map((d) => d.id).toList();
  }

  Future<void> addToWishlist(String uid, String productId) {
    return _wishlistRef(uid).doc(productId).set({'addedAt': DateTime.now().toIso8601String()});
  }

  Future<void> removeFromWishlist(String uid, String productId) {
    return _wishlistRef(uid).doc(productId).delete();
  }
}
