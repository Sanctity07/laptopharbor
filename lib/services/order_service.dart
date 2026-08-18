import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart';

class OrderService {
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection('orders');

  Future<String> placeOrder(OrderModel order) async {
    final doc = await _orders.add(order.toMap());
    return doc.id;
  }

  Stream<List<OrderModel>> streamOrders(String uid) {
    return _orders
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<OrderModel?> streamOrderById(String orderId) {
    return _orders.doc(orderId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return OrderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    });
  }
}
