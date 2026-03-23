import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'products.dart';
import 'accounts.dart';

final List<Order> sampleOrders = [
  Order(
    id: 'ORD-2024-001',
    accountId: 'acc-001',
    items: [
      CartItem(product: sampleProducts[0], quantity: 4), // TsingTao Lager 330ml 6-pack
      CartItem(product: sampleProducts[4], quantity: 6), // TsingTao Lager 640ml 12-pack
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
      CartItem(product: sampleProducts[1], quantity: 3), // TsingTao Lager 330ml 12-pack
      CartItem(product: sampleProducts[6], quantity: 2), // TsingTao Pure Draft 330ml 24-pack
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
      CartItem(product: sampleProducts[9], quantity: 5), // TsingTao 1903 500ml 12-pack
      CartItem(product: sampleProducts[13], quantity: 4), // TsingTao White Ale 330ml 12-pack
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
      CartItem(product: sampleProducts[12], quantity: 10), // TsingTao White Ale 330ml 6-pack
      CartItem(product: sampleProducts[3], quantity: 8), // TsingTao Lager 640ml 6-pack
    ],
    orderDate: DateTime.now().subtract(const Duration(days: 10)),
    deliveryDate: DateTime.now().subtract(const Duration(days: 7)),
    notes: 'Big summer event - stock up for the weekend.',
    status: OrderStatus.delivered,
    totalAmount: 224.82,
  ),
];
