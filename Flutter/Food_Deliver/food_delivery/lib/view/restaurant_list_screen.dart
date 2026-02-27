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
    final restaurantsAsync = ref.watch(restaurantListProvider);

    //it watches the cartProvider and rebuilds whenever the cart items change,
    // allowing the app bar to update the cart count in real-time as users add or remove items from their cart.
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    //fold is  a method on a list used to reduce the list to single value 
    //it combines the initial value, previous value and the curr item =>to caluculate total

    final totalCount = cartItems.fold(0, (sum, item) => sum + item.quantity);

    // search query state to filter the restaurant list based on user input in the search bar. 
    //As the user types, the searchQueryProvider updates, causing the restaurant list to rebuild and 
    //display only those restaurants that match the search criteria.
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,//foregroundColor sets the color of text and icons in the app bar to white
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FoodRush',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Delivering to: Home',
                style: TextStyle(fontSize: 12, color: Colors.white70)),//colors.white70=> means 70% opacity
                
          ],
        ),
        //actions are  right end of appbar
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen())),
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
                            color: Color(0xFFFF6B35),//)0x represents hexadecimal number and ff represnets opacity then rbg
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const OrdersScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFFFF6B35),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
//onchanged is a callback that gets triggered whenever the text in the TextField changes.
// that takes the current value as a paramater
//.notifier allows to update the state of the provider
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state =
                    value.toLowerCase();
              },
              decoration: InputDecoration(
                hintText: 'Search restaurants or food...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
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

          // Restaurant List
          Expanded(
            child: restaurantsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
              ),
              error: (e, s) =>
                  Center(child: Text('Something went wrong: $e')),
              data: (restaurants) {

                // Search filter
                final filtered = searchQuery.isEmpty
                    ? restaurants
                    : restaurants.where((r) {
                  return r.name
                      .toLowerCase()
                      .contains(searchQuery) ||
                      r.cuisine
                          .toLowerCase()
                          .contains(searchQuery);
                }).toList();

                // No results found
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          'No restaurants found\nfor "$searchQuery"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) =>
                      _RestaurantCard(restaurant: filtered[i]),
                );
              },
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
          ? () => Navigator.push(context,
          MaterialPageRoute(
              builder: (_) => MenuScreen(restaurant: restaurant)))
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
            //stack allows to place the closed text on top of the image when the restaurant is closed
            Stack(
              children: [
                //clipRRect is used to  crop or clip the image into a rounded rectangle shape, giving it rounded corners.
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
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
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(restaurant.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Row(children: [
                        const Icon(Icons.star,
                            size: 16, color: Color(0xFFFFB300)),
                        const SizedBox(width: 3),
                        Text(restaurant.rating.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(restaurant.cuisine,
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(children: [
                    //infochip =>shows the delivery time and delivery fee of the restaurant in a compact format with an icon and label.
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
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ]);
  }
}