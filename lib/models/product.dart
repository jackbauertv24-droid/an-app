import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String style;
  final double abv;
  final int packSize;
  final double price;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.style,
    required this.abv,
    required this.packSize,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  String get packSizeLabel {
    if (packSize == 6) return '6-Pack';
    if (packSize == 12) return '12-Pack';
    if (packSize == 24) return 'Case (24)';
    return '$packSize Pack';
  }

  String get displayPrice => '\$${price.toStringAsFixed(2)}';
}
