import 'package:flutter/material.dart';
import '../extensions/ref_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/restaurant.dart';
import '../model/app_state.dart';
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
    Future.microtask(
          () => ref.appNotifier.loadMenuItems(widget.restaurant.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.appState;
    final appNotifier = ref.appNotifier;
    final menuItems = appState.menuItems;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    final Map<String, List<FoodItem>> grouped = {};
    for (final item in menuItems) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ── Simple AppBar — no image inside ──
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        title: Text(
          widget.restaurant.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(children: [
            IconButton(
              key: const Key('cart'),
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => context.push('/cart'),
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

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 800 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Restaurant image — simple AspectRatio, no clipping ──
                AspectRatio(
                  aspectRatio: 16 / 7, // ✅ wide banner shape — full image visible
                  child: Image.network(
                    widget.restaurant.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,     // ✅ fills width perfectly
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFFF6B35),
                      child: const Icon(Icons.restaurant,
                          size: 60, color: Colors.white),
                    ),
                  ),
                ),

                // ── Info row ──
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    const Icon(Icons.star,
                        color: Color(0xFFFFB300), size: 18),
                    const SizedBox(width: 6),
                    Text('${widget.restaurant.rating}',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time,
                        color: Colors.grey, size: 18),
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

                // ── Menu items ──
                if (menuItems.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                          color: Color(0xFFFF6B35)),
                    ),
                  )
                else
                  ...grouped.entries.expand((entry) => [
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(entry.key,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    ...entry.value.map(
                          (item) => MenuItemCard(
                        key: Key('menu_item_${item.id}'),
                        item: item,
                        onAdd: () async {
                          await appNotifier.addItem(
                              item, widget.restaurant);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${item.name} added to cart'),
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                const Color(0xFFFF6B35),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ]),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),

      // ── Bottom cart button ──
      bottomNavigationBar: appState.itemCount > 0
          ? SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 300 : 16,
            vertical: 16,
          ),
          child: ElevatedButton(
            key: const Key('view_cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => context.push('/cart'),
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

class MenuItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAdd;

  const MenuItemCard(
      {super.key, required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.imageUrl,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 55,
              height: 55,
              color: Colors.grey[200],
              child: const Icon(Icons.fastfood, color: Colors.grey),
            ),
          ),
        ),
        title: Text(item.name,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('₹${item.price.toStringAsFixed(0)}',
            style: const TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
                fontSize: 13)),
        trailing: ElevatedButton(
          key: Key('add_${item.id}'),
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Add',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

extension AppStateExtensions on AppState {
  int get itemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
}