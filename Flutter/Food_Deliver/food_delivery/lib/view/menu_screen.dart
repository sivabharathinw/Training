import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant.dart';
import '../model/food_item.dart';
import '../viewmodel/view_model.dart';
import 'cart_screen.dart';

class MenuScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;
  const MenuScreen({super.key, required this.restaurant});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(appProvider.notifier).loadMenuItems(widget.restaurant.id));
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final menuItems = appState.menuItems;

    // Category-wise group பண்றோம்
    final Map<String, List<FoodItem>> grouped = {};
    for (final item in menuItems) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [

          // ── AppBar with restaurant image ──────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.restaurant.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 4)
                      ])),
              background: Image.network(
                widget.restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: const Color(0xFFFF6B35)),
              ),
            ),
            actions: [
              Stack(children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                ),
                if (appState.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Text('${appState.itemCount}',
                          style: const TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ]),
            ],
          ),

          // ── Restaurant Info Row ───────────────────────────
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
                Text('${widget.restaurant.rating}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, color: Colors.grey, size: 18),
                const SizedBox(width: 6),
                Text(widget.restaurant.deliveryTime),
                const SizedBox(width: 16),
                const Icon(Icons.delivery_dining,
                    color: Colors.grey, size: 18),
                const SizedBox(width: 6),
                Text(widget.restaurant.deliveryFee == 0
                    ? 'Free'
                    : '₹${widget.restaurant.deliveryFee.toStringAsFixed(0)}'),
              ]),
            ),
          ),

          // ── Menu Items ────────────────────────────────────
          menuItems.isEmpty
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                          color: Color(0xFFFF6B35)),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                    // Category-wise list
                    ...grouped.entries.expand((entry) => [
                          // Category header
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(entry.key,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                          // Items under category
                          ...entry.value.map((item) => _MenuItemCard(
                                item: item,
                                onAdd: () async {
                                  await appNotifier.addItem(
                                      item, widget.restaurant);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '${item.name} added to cart'),
                                      duration:
                                          const Duration(seconds: 1),
                                      backgroundColor:
                                          const Color(0xFFFF6B35),
                                    ));
                                  }
                                },
                              )),
                        ]),
                    const SizedBox(height: 100),
                  ]),
                ),
        ],
      ),

      // ── View Cart Bottom Bar ──────────────────────────────
      bottomNavigationBar: appState.itemCount > 0
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CartScreen()),
                  ),
                  child: Text(
                    'View Cart (${appState.itemCount} items) • ₹${appState.totalPrice.toStringAsFixed(0)}',
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

// ── Menu Item Card ────────────────────────────────────────────

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
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(item.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[100],
                  child:
                      const Icon(Icons.fastfood, color: Colors.grey))),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: Colors.grey[600], fontSize: 12)),
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
