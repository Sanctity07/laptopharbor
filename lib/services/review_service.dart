import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  final CollectionReference _reviews =
      FirebaseFirestore.instance.collection('reviews');

  Future<List<Review>> fetchReviewsForProduct(String productId) async {
    final snap = await _reviews.where('productId', isEqualTo: productId).get();
    return snap.docs
        .map((d) => Review.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addReview(Review review) {
    return _reviews.add(review.toMap());
  }
}
