import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../extensions/ref_extensions.dart';
import '../viewmodel/view_model.dart';
import 'orders_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../extensions/ref_extensions.dart';
import '../viewmodel/view_model.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.appState;
    final appNotifier = ref.appNotifier;
    final cartItems = appState.cartItems;
    final deliveryFee = 19.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        title: const Text(
          'Your Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items from a restaurant',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cartItems[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12),
                        ),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.foodItemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.restaurantName,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6B35),
                                      fontSize: 15,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _QtyButton(
                                        icon: Icons.remove,
                                        onTap: () =>
                                            appNotifier.decreaseQuantity(
                                                item),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      _QtyButton(
                                        icon: Icons.add,
                                        onTap: () =>
                                            appNotifier.increaseQuantity(
                                                item),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () =>
                                            appNotifier.removeItem(item.id),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bill Summary + Place Order
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                _BillRow(
                  label: 'Subtotal',
                  value:
                  '₹${appState.totalPrice.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 6),
                _BillRow(
                  label: 'Delivery Fee',
                  value: '₹${deliveryFee.toStringAsFixed(0)}',
                ),
                const Divider(height: 20),
                _BillRow(
                  label: 'Total',
                  value:
                  '₹${(appState.totalPrice + deliveryFee).toStringAsFixed(0)}',
                  isBold: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final restaurantName =
                          cartItems.first.restaurantName;
                      final total = appState.totalPrice + deliveryFee;

                      await appNotifier.placeOrder(
                        cartItems: cartItems.toList(),
                        restaurantName: restaurantName,
                        totalAmount: total,
                        deliveryAddress: 'Home',
                      );
                      await appNotifier.clearCart();

                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8),
                                Text('Order Placed!'),
                              ],
                            ),
                            content: Text(
                              'Your order from $restaurantName has been placed successfully!',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  GoRouter.of(context).go('/orders');
                                },
                                child: const Text('View Orders'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Place Order • ₹${(appState.totalPrice + deliveryFee).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _BillRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}