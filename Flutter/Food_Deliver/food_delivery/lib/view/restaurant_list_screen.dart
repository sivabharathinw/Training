import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../extensions/ref_extensions.dart';
import 'package:go_router/go_router.dart';
import '../model/restaurant.dart';
import '../viewmodel/view_model.dart';
import 'menu_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';

class RestaurantListScreen extends ConsumerWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.appState;
    final appNotifier = ref.appNotifier;
    final totalCount = appState.itemCount;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FoodRush',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Delivering to: Home',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                key: const Key('cart'),
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => GoRouter.of(context).push('/cart'),
              ),
              if (totalCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
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
            key: const Key('orders'),
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => GoRouter.of(context).push('/orders'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ──
          Container(
            color: const Color(0xFFFF6B35),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: isWeb ? 700 : double.infinity),
                child: TextField(
                  key: const Key('search'),
                  onChanged: (value) => appNotifier.updateSearch(value),
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
            ),
          ),

          // ── Restaurant List ──
          Expanded(
            child: appState.restaurants.isEmpty
                ? const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFFF6B35)))
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
                        color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            )
                : isWeb
            // ── WEB: 3 column grid ──
                ? GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // square cards
              ),
              itemCount:
              appNotifier.filteredRestaurants.length,
              itemBuilder: (ctx, i) => _RestaurantCard(
                key: Key('restaurant_$i'),
                restaurant:
                appNotifier.filteredRestaurants[i],
              ),
            )
            // ── MOBILE: normal list ──
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
              appNotifier.filteredRestaurants.length,
              itemBuilder: (ctx, i) => _RestaurantCard(
                key: Key('restaurant_$i'),
                restaurant:
                appNotifier.filteredRestaurants[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return GestureDetector(
      onTap: restaurant.isOpen
          ? () => GoRouter.of(context).push('/menu', extra: restaurant)
          : null,
      child: Container(
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
            // ── Image takes 65% of card height ──
            Expanded(
              flex: 65,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: SizedBox.expand( // fills exactly its flex space
                      child: Image.network(
                        restaurant.imageUrl,
                        fit: BoxFit.cover, //  covers without distorting
                        errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.restaurant,
                                size: 48, color: Colors.grey)),
                      ),
                    ),
                  ),
                  if (!restaurant.isOpen)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Container(
                          color: Colors.black54,
                          child: const Center(
                            child: Text('CLOSED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 2)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info takes 35% of card height ──
            Expanded(
              flex: 35,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: isWeb ? 13 : 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(children: [
                          const Icon(Icons.star,
                              size: 13, color: Color(0xFFFFB300)),
                          const SizedBox(width: 2),
                          Text(restaurant.rating.toString(),
                              style: TextStyle(
                                  fontSize: isWeb ? 11 : 13,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ],
                    ),
                    Text(
                      restaurant.cuisine,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isWeb ? 11 : 13),
                    ),
                    Row(children: [
                      _InfoChip(
                          icon: Icons.access_time,
                          label: restaurant.deliveryTime,
                          isWeb: isWeb),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.delivery_dining,
                        label: restaurant.deliveryFee == 0
                            ? 'Free'
                            : '₹${restaurant.deliveryFee.toStringAsFixed(0)}',
                        isWeb: isWeb,
                      ),
                    ]),
                  ],
                ),
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
  final bool isWeb;
  const _InfoChip(
      {required this.icon, required this.label, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 12, color: Colors.grey[500]),
      const SizedBox(width: 3),
      Text(label,
          style: TextStyle(
              fontSize: isWeb ? 10 : 12, color: Colors.grey[600])),
    ]);
  }
}