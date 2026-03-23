import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/account_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_summary_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderHistory),
        backgroundColor: const Color(0xFFD4A054),
        foregroundColor: Colors.white,
      ),
      body: Consumer2<AccountProvider, OrdersProvider>(
        builder: (context, accountProvider, ordersProvider, child) {
          final account = accountProvider.currentAccount;

          if (account == null) {
            return Center(
              child: Text(l10n.noAccountSelected),
            );
          }

          final orders = ordersProvider.ordersForAccount(account.id);

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noOrdersYet,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.orderHistoryWillAppear,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderSummaryCard(
                order: order,
                onTap: () {
                  _showOrderDetails(context, order, l10n);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showOrderDetails(BuildContext context, order, AppLocalizations l10n) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.id,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: order.statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              order.statusLabel,
                              style: TextStyle(
                                color: order.statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.orders,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 50,
                                  height: 50,
                                  color: const Color(0xFFF5E6D3),
                                  child: const Icon(
                                    Icons.local_drink,
                                    color: Color(0xFFD4A054),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    item.product.packSizeLabel,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${l10n.quantity}: ${item.quantity}'),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD4A054),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.total,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4A054),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.calendar_today, l10n.ordered, dateFormat.format(order.orderDate)),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.local_shipping, l10n.delivery, dateFormat.format(order.deliveryDate)),
                      if (order.notes.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          l10n.orderNotes,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(order.notes),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: $value',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }
}
