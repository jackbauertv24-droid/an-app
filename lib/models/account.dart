import 'package:flutter/material.dart';

class Account {
  final String id;
  final String name;
  final String type;
  final String address;
  final String contactPhone;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.contactPhone,
  });

  IconData get typeIcon {
    switch (type.toLowerCase()) {
      case 'bar':
        return Icons.local_bar;
      case 'restaurant':
        return Icons.restaurant;
      case 'retail':
        return Icons.store;
      default:
        return Icons.business;
    }
  }
}
