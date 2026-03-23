import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../data/products.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _orders = [];
  static const String _ordersKey = 'saved_orders';
  bool _initialized = false;

  List<Order> get orders => List.unmodifiable(_orders..sort((a, b) => b.orderDate.compareTo(a.orderDate)));

  OrdersProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString(_ordersKey);

      if (ordersJson != null) {
        final List<dynamic> decoded = json.decode(ordersJson);
        _orders = decoded.map((o) => _orderFromJson(o)).toList();
      } else {
        // Load sample orders if no saved orders exist
        _loadSampleOrders();
      }
    } catch (e) {
      _loadSampleOrders();
    }

    _initialized = true;
    notifyListeners();
  }

  void _loadSampleOrders() {
    _orders = [
      Order(
        id: 'ORD-2024-001',
        accountId: 'acc-001',
        items: [
          CartItem(product: sampleProducts[0], quantity: 4),
          CartItem(product: sampleProducts[4], quantity: 6),
        ],
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 5)),
        notes: 'Please deliver before 4 PM for happy hour setup.',
        status: OrderStatus.delivered,
        totalAmount: 203.90,
      ),
      Order(
        id: 'ORD-2024-002',
        accountId: 'acc-001',
        items: [
          CartItem(product: sampleProducts[1], quantity: 3),
          CartItem(product: sampleProducts[6], quantity: 2),
        ],
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        notes: 'Call on arrival - back entrance preferred.',
        status: OrderStatus.confirmed,
        totalAmount: 128.95,
      ),
      Order(
        id: 'ORD-2024-003',
        accountId: 'acc-002',
        items: [
          CartItem(product: sampleProducts[9], quantity: 5),
          CartItem(product: sampleProducts[13], quantity: 4),
        ],
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        deliveryDate: DateTime.now().add(const Duration(days: 2)),
        notes: 'Weekend dinner service replenishment.',
        status: OrderStatus.pending,
        totalAmount: 195.91,
      ),
      Order(
        id: 'ORD-2024-004',
        accountId: 'acc-003',
        items: [
          CartItem(product: sampleProducts[12], quantity: 10),
          CartItem(product: sampleProducts[3], quantity: 8),
        ],
        orderDate: DateTime.now().subtract(const Duration(days: 10)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 7)),
        notes: 'Big summer event - stock up for the weekend.',
        status: OrderStatus.delivered,
        totalAmount: 224.82,
      ),
    ];
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = json.encode(_orders.map((o) => _orderToJson(o)).toList());
      await prefs.setString(_ordersKey, ordersJson);
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }

  Map<String, dynamic> _orderToJson(Order order) {
    return {
      'id': order.id,
      'accountId': order.accountId,
      'items': order.items.map((item) => {
        'productId': item.product.id,
        'quantity': item.quantity,
      }).toList(),
      'orderDate': order.orderDate.toIso8601String(),
      'deliveryDate': order.deliveryDate.toIso8601String(),
      'notes': order.notes,
      'status': order.status.index,
      'totalAmount': order.totalAmount,
    };
  }

  Order _orderFromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List).map((itemJson) {
      final productId = itemJson['productId'];
      final product = sampleProducts.firstWhere(
        (p) => p.id == productId,
        orElse: () => sampleProducts[0],
      );
      return CartItem(product: product, quantity: itemJson['quantity']);
    }).toList();

    return Order(
      id: json['id'],
      accountId: json['accountId'],
      items: items,
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      notes: json['notes'] ?? '',
      status: OrderStatus.values[json['status'] ?? 0],
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }

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

  Future<void> addOrder({
    required String accountId,
    required List<CartItem> items,
    required DateTime deliveryDate,
    required String notes,
  }) async {
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
    await _saveOrders();
    notifyListeners();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
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
      await _saveOrders();
      notifyListeners();
    }
  }

  Future<void> clearOrders() async {
    _orders.clear();
    await _saveOrders();
    notifyListeners();
  }
}
