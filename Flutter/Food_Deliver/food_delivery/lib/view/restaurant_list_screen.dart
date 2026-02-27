import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant.dart';
import '../viewmodel/view_model.dart';
import 'menu_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';

class RestaurantListScreen extends ConsumerWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final totalCount = appState.itemCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FoodRush',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Delivering to: Home',
                style:
                    TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CartScreen())),
              ),
              if (totalCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle),
                    child: Text('$totalCount',
                        style: const TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const OrdersScreen())),
          ),
        ],
      ),
      body: Column(
        children: [

          Container(
            color: const Color(0xFFFF6B35),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
              onChanged: (value) {
                appNotifier.updateSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search restaurants or cuisine...',
                prefixIcon:
                    const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

      
          Expanded(
            child: appState.isLoading

                // Loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFFF6B35)),
                  )

                // No results
                : appNotifier.filteredRestaurants.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 60, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text(
                              'No restaurants found\nfor "${appState.searchQuery}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      )

                    // Restaurant cards
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            appNotifier.filteredRestaurants.length,
                        itemBuilder: (ctx, i) => _RestaurantCard(
                            restaurant:
                                appNotifier.filteredRestaurants[i]),
                      ),
          ),
        ],
      ),
    );
  }
}



class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: restaurant.isOpen
          ? () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      MenuScreen(restaurant: restaurant)))
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Restaurant image + CLOSED overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: Image.network(
                    restaurant.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant,
                            size: 60, color: Colors.grey)),
                  ),
                ),
                if (!restaurant.isOpen)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16))),
                      child: const Center(
                        child: Text('CLOSED',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 2)),
                      ),
                    ),
                  ),
              ],
            ),

            // Restaurant info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(restaurant.name,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      Row(children: [
                        const Icon(Icons.star,
                            size: 16,
                            color: Color(0xFFFFB300)),
                        const SizedBox(width: 3),
                        Text(restaurant.rating.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(restaurant.cuisine,
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(children: [
                    _InfoChip(
                        icon: Icons.access_time,
                        label: restaurant.deliveryTime),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: Icons.delivery_dining,
                      label: restaurant.deliveryFee == 0
                          ? 'Free delivery'
                          : '₹${restaurant.deliveryFee.toStringAsFixed(0)} delivery',
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: Colors.grey[500]),
      const SizedBox(width: 4),
      Text(label,
          style:
              TextStyle(fontSize: 12, color: Colors.grey[600])),
    ]);
  }
}
