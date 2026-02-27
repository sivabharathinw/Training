// lib/view/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/order.dart';
import '../viewmodel/view_model.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? _EmptyOrders()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (ctx, i) => _OrderCard(order: orders[i]),//here ctx is the context and i is the index of the order in the list of orders. we are passing the order at index i to the _OrderCard widget to display the details of that order.
            ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No orders yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Your order history will appear here',
              style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  Color _statusColor(String status) {
    return switch (status) {
      'placed' => const Color(0xFF2196F3),
      'preparing' => const Color(0xFFFF9800),
      'on_the_way' => const Color(0xFF9C27B0),
      'delivered' => const Color(0xFF4CAF50),
      _ => Colors.grey,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'placed' => Icons.check_circle_outline,
      'preparing' => Icons.restaurant,
      'on_the_way' => Icons.delivery_dining,
      'delivered' => Icons.done_all,
      _ => Icons.help_outline,
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      'placed' => 'Order Placed',
      'preparing' => 'Preparing',
      'on_the_way' => 'On the Way',
      'delivered' => 'Delivered',
      _ => status,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(_statusIcon(order.status), color: color),
                const SizedBox(width: 8),
                Text(
                  _statusLabel(order.status),
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Spacer(),
                Text(
                  '#${order.id}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.restaurant, size: 16, color: Color(0xFFFF6B35)),
                    const SizedBox(width: 6),
                    Text(
                      order.restaurantName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Items
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('${item.quantity}x',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item.foodItemName)),
                          Text('₹${item.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )),

                const Divider(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Paid',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFFFF6B35)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Placed on',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          _formatDate(order.placedAt),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.deliveryAddress,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}, ${_pad(dt.hour)}:${_pad(dt.minute)}';
  }
//here String _pad(int n) is a helper function that pads the hour and minute with a leading zero if they are less than 10, 
//to ensure that the time is always displayed in a consistent format (e.g., 09:05 instead of 9:5).
  String _pad(int n) => n.toString().padLeft(2, '0');
}
