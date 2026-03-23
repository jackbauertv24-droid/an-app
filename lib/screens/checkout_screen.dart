import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/account_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 2));
  final TextEditingController _notesController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD4A054),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  Future<void> _placeOrder(BuildContext context) async {
    final l10n = context.l10n;
    final accountProvider = context.read<AccountProvider>();
    final cartProvider = context.read<CartProvider>();
    final ordersProvider = context.read<OrdersProvider>();

    if (accountProvider.currentAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noAccountSelected)),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Add order to provider (which persists to local storage)
    await ordersProvider.addOrder(
      accountId: accountProvider.currentAccount!.id,
      items: List.from(cartProvider.items),
      deliveryDate: _deliveryDate,
      notes: _notesController.text,
    );

    // Get the newly created order
    final newOrder = ordersProvider.orders.first;
    final totalAmount = cartProvider.totalAmount;

    // Clear the cart
    cartProvider.clear();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
            orderId: newOrder.id,
            totalAmount: totalAmount,
            deliveryDate: _deliveryDate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkout),
        backgroundColor: const Color(0xFFD4A054),
        foregroundColor: Colors.white,
      ),
      body: Consumer2<CartProvider, AccountProvider>(
        builder: (context, cart, accountProvider, child) {
          if (cart.isEmpty) {
            return Center(
              child: Text(l10n.yourCartIsEmpty),
            );
          }

          final account = accountProvider.currentAccount;
          final accountName = account != null ? l10n.getAccountName(account.id) : l10n.noAccountSelected;
          final accountType = account != null ? l10n.getAccountType(account.type) : '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Account
                _buildSectionTitle(l10n.deliveryAccount),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          account?.typeIcon ?? Icons.business,
                          color: const Color(0xFFD4A054),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accountName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                account?.address ?? '',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                              Text(
                                account?.contactPhone ?? '',
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Delivery Date
                _buildSectionTitle(l10n.deliveryDate),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today, color: Color(0xFFD4A054)),
                    title: Text(dateFormat.format(_deliveryDate)),
                    subtitle: Text(
                      l10n.tapToChangeDate,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectDeliveryDate(context),
                  ),
                ),
                const SizedBox(height: 24),

                // Order Notes
                _buildSectionTitle(l10n.orderNotesOptional),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: l10n.deliveryInstructions,
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Order Summary
                _buildSectionTitle(l10n.orderSummary),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...cart.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x ${l10n.getProductName(item.product.id)}',
                                ),
                              ),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )),
                        const Divider(height: 24),
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
                              '\$${cart.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4A054),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomSheet: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : () => _placeOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A054),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      l10n.placeOrder,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3E2723),
        ),
      ),
    );
  }
}
