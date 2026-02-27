// lib/view/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cart_item.dart';
import '../viewmodel/view_model.dart';
import 'orders_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text('Remove all items from cart?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Clear', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) await cartNotifier.clearCart();
              },
              child: const Text('Clear', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _EmptyCart()
          : _CartContent(cartItems: cartItems, cartNotifier: cartNotifier),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Your cart is empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Add items from a restaurant to get started',
              style: TextStyle(color: Colors.grey[500])),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Browse Restaurants'),
          ),
        ],
      ),
    );
  }
}
//consumer stateful widget is used when we need to manage state that can change over time and also want to listen to providers. 
// we need to manage the state of the address input and also listen to the cart provider for updates on cart items and total price.

class _CartContent extends ConsumerStatefulWidget {
  final List<CartItem> cartItems;
  //cart notifier is used to perform actions like increasing/decreasing quantity, removing items, and clearing the cart.
  // we need to pass it down to the cart item tiles and also use it to calculate the total price and place the order.
  final CartNotifier cartNotifier;
  const _CartContent({required this.cartItems, required this.cartNotifier});

  @override
  ConsumerState<_CartContent> createState() => _CartContentState();
}

class _CartContentState extends ConsumerState<_CartContent> {
  final _addressController = TextEditingController(text: '123 Main Street, chennai');
//dispose method is used to cleanup the address controller when the widget is removed from the widget tree to prevent memory leaks.
  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_addressController.text.trim().isEmpty) {
      // Show error if address is empty please enter a delivery address
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a delivery address')),
      );
      return;
    }

    final ordersNotifier = ref.read(ordersProvider.notifier);
    final restaurantName = widget.cartItems.first.restaurantName;//here widget is  used to access the properties of the _CartContent widget from its state class.
     //we need to get the restaurant name from the first cart item to pass it to the placeOrder method.
    final total = widget.cartNotifier.totalPrice;

    await ordersNotifier.placeOrder(
      cartItems: widget.cartItems,
      restaurantName: restaurantName,
      totalAmount: total,
      deliveryAddress: _addressController.text.trim(),
    );

    await widget.cartNotifier.clearCart();

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70, height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('Order Placed!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Your order has been placed successfully. Estimated delivery in 30–45 min.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersScreen()),
                  );
                },
                child: const Text('Track Order'),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryFee = 29.0;
    final subtotal = widget.cartNotifier.totalPrice;
    final total = subtotal + deliveryFee;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Restaurant name
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.restaurant, color: Color(0xFFFF6B35)),
                    const SizedBox(width: 10),
                    Text(
                      widget.cartItems.first.restaurantName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),

              // Cart items
              ...widget.cartItems.map((item) => _CartItemTile(
                    item: item,
                    onIncrease: () => widget.cartNotifier.increaseQuantity(item),
                    onDecrease: () => widget.cartNotifier.decreaseQuantity(item),
                    onRemove: () => widget.cartNotifier.removeItem(item.id),
                  )),

              const SizedBox(height: 16),

              // address
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFFFF6B35)),
                        SizedBox(width: 8),
                        Text('Delivery Address',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter your delivery address',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bill summary
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bill Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 12),
                    _BillRow(label: 'Item Total', value: '₹${subtotal.toStringAsFixed(0)}'),
                    _BillRow(label: 'Delivery Fee', value: '₹${deliveryFee.toStringAsFixed(0)}'),
                    const Divider(height: 20),
                    _BillRow(
                      label: 'To Pay',
                      value: '₹${total.toStringAsFixed(0)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Place Order Button
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _placeOrder,
              child: Text(
                //toStringAsFixed(0) is used to convert the total price to a string with no decimal places
                'Place Order • ₹${total.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  
  final VoidCallback onIncrease, onDecrease, onRemove;
  //this is the cartitemti;e constructor which takes the cart item and the callbacks for increasing, decreasing, and removing the item from the cart. we need to pass these callbacks to the quantity buttons and the remove button in the tile.
  const _CartItemTile(
      {required this.item,
      required this.onIncrease,
      required this.onDecrease,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 60, height: 60,
              fit: BoxFit.cover,
              //error
             // when the image fails to load then it will show a grey box with a fast food icon in the center.
              errorBuilder: (_, __, ___) =>
                  Container(width: 60, height: 60, color: Colors.grey[100],
                      child: const Icon(Icons.fastfood, color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.foodItemName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('₹${item.price.toStringAsFixed(0)} each',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35)),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _QtyButton(icon: Icons.remove, onTap: onDecrease),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  _QtyButton(icon: Icons.add, onTap: onIncrease),
                ],
              ),
            ],
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
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B35),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
