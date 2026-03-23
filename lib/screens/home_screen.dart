import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../data/products.dart';
import '../providers/account_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'developer_menu_screen.dart';
import 'account_selection_screen.dart';

class _SnackbarAwareFabLocation extends FloatingActionButtonLocation {
  final double offset;

  const _SnackbarAwareFabLocation({this.offset = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final baseOffset = FloatingActionButtonLocation.endFloat
        .getOffset(scaffoldGeometry);
    return Offset(baseOffset.dx, baseOffset.dy - offset);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _snackbarOffset = 0;

  void _showAddToCartSnackBar(String productName, AppLocalizations l10n) {
    setState(() => _snackbarOffset = 56);

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text('$productName ${l10n.addToCart}'),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: l10n.cart,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
          ),
        )
        .closed
        .then((_) {
          if (mounted) {
            setState(() => _snackbarOffset = 0);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: const Color(0xFFD4A054),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );
            },
            tooltip: l10n.orderHistory,
          ),
        ],
      ),
      drawer: Consumer<AccountProvider>(
        builder: (context, accountProvider, child) {
          final account = accountProvider.currentAccount;
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4A054),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.local_drink,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        account != null
                            ? l10n.getAccountName(account.id)
                            : l10n.noAccountSelected,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        account != null ? l10n.getAccountType(account.type) : '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(l10n.productCatalog),
                  selected: true,
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(l10n.orderHistory),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(l10n.developerMenu),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DeveloperMenuScreen()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.switch_account),
                  title: Text(l10n.switchAccount),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.switchAccount),
                        content: Text(l10n.confirmLogout),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(l10n.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const AccountSelectionScreen()),
                              );
                            },
                            child: Text(l10n.logout),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF5E6D3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.wholesalerBrand,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.wholesaleDistribution,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<AccountProvider>(
                    builder: (context, accountProvider, child) {
                      final account = accountProvider.currentAccount;
                      return Text(
                        '${l10n.welcome}, ${account != null ? l10n.getAccountName(account.id) : "Guest"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.productsAvailableText(sampleProducts.length),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: sampleProducts.length,
                itemBuilder: (context, index) {
                  final product = sampleProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    onAddToCart: () {
                      context.read<CartProvider>().addItem(product);
                      _showAddToCartSnackBar(
                          l10n.getProductName(product.id), l10n);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          _SnackbarAwareFabLocation(offset: _snackbarOffset),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            backgroundColor: const Color(0xFFD4A054),
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: Row(
              children: [
                Text(
                  '${l10n.cart} (${cartProvider.itemCount})',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}