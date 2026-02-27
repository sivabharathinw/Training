import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant.dart';
import '../model/food_item.dart';
import '../viewmodel/view_model.dart';
import 'cart_screen.dart';

class MenuScreen extends ConsumerWidget {
  final Restaurant restaurant;
  const MenuScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuItemsProvider(restaurant.id));
    final cartNotifier = ref.read(cartProvider.notifier);
    final totalCount = cartNotifier.itemCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant.name,
                  style: const TextStyle(fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
              background: Image.network(restaurant.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFFF6B35))),
            ),
            actions: [
              Stack(children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: totalCount > 0
                      ? () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const CartScreen()))
                      : null,
                ),
                if (totalCount > 0)
                  Positioned(
                    right: 6, top: 6,
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
              ]),
            ],
          ),

          // Restaurant info row in the restaurant details page that shows the rating, delivery time and delivery fee of the restaurant.
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.star, color: Color(0xFFFFB300), size: 18),
                const SizedBox(width: 6),
                Text('${restaurant.rating}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, color: Colors.grey, size: 18),
                const SizedBox(width: 6),
                Text(restaurant.deliveryTime),
                const SizedBox(width: 16),
                const Icon(Icons.delivery_dining, color: Colors.grey, size: 18),
                const SizedBox(width: 6),
                Text('₹${restaurant.deliveryFee.toStringAsFixed(0)}'),
              ]),
            ),
          ),

          // Menu items
          menuAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
                ),
              ),
            ),
            error: (e, s) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e'))),
            data: (menuItems) {
              final Map<String, List<FoodItem>> grouped = {};
              for (final item in menuItems) {
                grouped.putIfAbsent(item.category, () => []).add(item);
              }
              return SliverList(
                //delegate is used to build the list of menu items in the restaurant details page. it takes a list of widgets and builds them  as they scroll into view.
                delegate: SliverChildListDelegate([
                  ...grouped.entries.expand((entry) => [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(entry.key,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...entry.value.map((item) => _MenuItemCard(
                      item: item,
                      onAdd: () async {
                        await cartNotifier.addItem(item, restaurant);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${item.name} added to cart'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: const Color(0xFFFF6B35),
                        ));
                      },
                    )),
                  ]),
                  const SizedBox(height: 100),
                ]),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: totalCount > 0
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartScreen())),
                  child: Text(
                    'View Cart ($totalCount items) • ₹${cartNotifier.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAdd;
  const _MenuItemCard({required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(item.imageUrl,
              width: 90, height: 90, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 90, height: 90, color: Colors.grey[100],
                  child: const Icon(Icons.fastfood, color: Colors.grey))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(item.description,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFFF6B35))),
                  GestureDetector(
                    onTap: item.isAvailable ? onAdd : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: item.isAvailable
                            ? const Color(0xFFFF6B35)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.isAvailable ? 'ADD' : 'N/A',
                        style: TextStyle(
                            color: item.isAvailable
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}