import '../../models/review.dart';

/// Placeholder reviews for UI-first development.
/// TODO: remove once ReviewService pulls from Firestore.
final List<Review> mockReviews = [
  Review(
    id: 'r1',
    productId: 'l1',
    userId: 'u1',
    userName: 'James Smith',
    rating: 5,
    comment:
        'The display is absolutely world-class. As a designer, color accuracy is everything, and this machine delivers beyond expectations. Build quality feels like a tank.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Review(
    id: 'r2',
    productId: 'l1',
    userId: 'u2',
    userName: 'Alex Wong',
    rating: 4,
    comment:
        'Incredible speed for compilation tasks. The thermal management is impressive—it stays quiet even under heavy load. Only wish the battery lasted just a bit longer.',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Review(
    id: 'r3',
    productId: 'l1',
    userId: 'u3',
    userName: 'Elena K.',
    rating: 5,
    comment:
        "Best investment for my workstation. The connectivity options mean I don't need dongles anymore. LaptopHarbor support was also very helpful during setup.",
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
  ),
];