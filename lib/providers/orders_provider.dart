import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../data/sample_orders.dart';

class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = List.from(sampleOrders);

  List<Order> get orders => List.unmodifiable(_orders..sort((a, b) => b.orderDate.compareTo(a.orderDate)));

  List<Order> ordersForAccount(String accountId) {
    return _orders
        .where((order) => order.accountId == accountId)
        .toList()
      ..sort((a, b) => b.orderDate.compareTo(a.orderDate));
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (_) {
      return null;
    }
  }

  void addOrder({
    required String accountId,
    required List<CartItem> items,
    required DateTime deliveryDate,
    required String notes,
  }) {
    final totalAmount = items.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final orderNumber = _orders.length + 1;

    final newOrder = Order(
      id: 'ORD-${DateTime.now().year}-${orderNumber.toString().padLeft(3, '0')}',
      accountId: accountId,
      items: items.map((item) => CartItem(
        product: item.product,
        quantity: item.quantity,
      )).toList(),
      orderDate: DateTime.now(),
      deliveryDate: deliveryDate,
      notes: notes,
      status: OrderStatus.pending,
      totalAmount: totalAmount,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final order = _orders[index];
      _orders[index] = Order(
        id: order.id,
        accountId: order.accountId,
        items: order.items,
        orderDate: order.orderDate,
        deliveryDate: order.deliveryDate,
        notes: order.notes,
        status: status,
        totalAmount: order.totalAmount,
      );
      notifyListeners();
    }
  }
}
