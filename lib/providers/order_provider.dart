import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  List<OrderModel> orders = [];

  void listenToOrders(String uid) {
    _service.streamOrders(uid).listen((data) {
      orders = data;
      notifyListeners();
    });
  }

  Future<String> placeOrder(OrderModel order) => _service.placeOrder(order);
}
