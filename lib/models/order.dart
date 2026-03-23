import 'package:flutter/material.dart';
import 'cart_item.dart';

enum OrderStatus { pending, confirmed, delivered }

class Order {
  final String id;
  final String accountId;
  final List<CartItem> items;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String notes;
  final OrderStatus status;
  final double totalAmount;

  const Order({
    required this.id,
    required this.accountId,
    required this.items,
    required this.orderDate,
    required this.deliveryDate,
    required this.notes,
    required this.status,
    required this.totalAmount,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFA726);
      case OrderStatus.confirmed:
        return const Color(0xFF42A5F5);
      case OrderStatus.delivered:
        return const Color(0xFF66BB6A);
    }
  }
}
