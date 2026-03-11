import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_collection/built_collection.dart';
import 'package:food_delivery/repository/app_repository.dart';
import '../model/restaurant.dart';
import '../model/food_item.dart';
import '../model/cart_item.dart';
import '../model/order.dart';
import '../model/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:food_delivery/model/serializers.dart';
import 'dart:async';//for streams
final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  final repo = AppRepository();
  return AppNotifier(repo);
});

class AppNotifier extends StateNotifier<AppState> {
  //StreamSubscription is a connection between app and stream it can listen the streams ,pasuse and cancel the streams

  StreamSubscription? _ordersSubscription;

  final AppRepository repository;

  Future<bool> login(String email, String password) async {
    final error = await repository.auth.login(email, password);

    return error == null;
  }
  Future<bool> signUp(String email, String password) async {
    final error = await repository.auth.signUp(email, password);

    return error==null;
  }
  Future<void> logout() async {
    await repository.auth.logout();
  }
  Future<void> addUser({required String name, required String email}) async {
    await repository.firestore.addUser(name: name, email: email);
  }
  get _storage => repository.localStorageServiceProvider;


  AppNotifier(this.repository) : super(AppState((b) => b
    ..restaurants = ListBuilder<Restaurant>()
    ..menuItems = ListBuilder<FoodItem>()
    ..cartItems = ListBuilder<CartItem>()
    ..orders = ListBuilder<Order>()
    ..searchQuery = '')) {
    _init();
  }

  Future<void> _init() async {
    await repository.init();
    await _loadRestaurants();
    await _loadCart();
    _loadOrders();
  }
//in updateState  it have restaurants, menuItems, cartItems, orders, searchQuery.
  //it is in optional parameters, so we can update any of them without affecting the others.
  void _updateState({
    List<Restaurant>? restaurants,
    List<FoodItem>? menuItems,
    List<CartItem>? cartItems,
    List<Order>? orders,
    String? searchQuery,
  }) {
    //state is immutable, so we need to rebuild it with the new values. We only update the fields that are provided, leaving the others unchanged.
    state = state.rebuild((b) {
      if (restaurants != null) b.restaurants = ListBuilder(restaurants);
      if (menuItems != null) b.menuItems = ListBuilder(menuItems);
      if (cartItems != null) b.cartItems = ListBuilder(cartItems);
      if (orders != null) b.orders = ListBuilder(orders);
      if (searchQuery != null) b.searchQuery = searchQuery;
    });
  }

  Future<void> _loadRestaurants() async {
    final existing = await repository.firestore.getRestaurants();

      if(existing.isEmpty) {
        await repository.firestore.insertAllRestaurants(_sampleRestaurants);
        await repository.firestore.insertAllFoodItems(_sampleFoodItems);
        _updateState(restaurants: _sampleRestaurants);
      } else {
        _updateState(restaurants: existing);
      }
  }


  Future<void> loadMenuItems(int restaurantId) async {
    final items = await repository.firestore.getFoodItems(restaurantId);
    _updateState(menuItems: items);
  }

  Future<void> _loadCart() async {
    final items = await repository.firestore.getCartItems();
    _updateState(cartItems: items);
  }

  Future<void> addItem(FoodItem foodItem, Restaurant restaurant) async {
    final cartItem = CartItem((b) => b
      ..id = 0
      ..foodItemId = foodItem.id
      ..foodItemName = foodItem.name
      ..price = foodItem.price
      ..imageUrl = foodItem.imageUrl
      ..quantity = 1
      ..restaurantId = restaurant.id
      ..restaurantName = restaurant.name);

    await repository.firestore.addCartItem(cartItem);
    await _loadCart();
  }

  Future<void> increaseQuantity(CartItem item) async {
    await repository.firestore.updateCartItemQuantity(item.id, item.quantity + 1);
    await _loadCart();
  }

  Future<void> decreaseQuantity(CartItem item) async {
    if (item.quantity <= 1) {
      await repository.firestore.removeCartItem(item.id);
    } else {
      await repository.firestore.updateCartItemQuantity(item.id, item.quantity - 1);
    }
    await _loadCart();
  }
  Future<void> addToCart(CartItem item) async {
    await repository.firestore.addCartItem(item);
  }

  Future<void> removeItem(int cartItemId) async {
    await repository.firestore.removeCartItem(cartItemId);
    await _loadCart();
  }

  Future<void> clearCart() async {
    await repository.firestore.clearCart();
    _updateState(cartItems: []);
  }

  Future<void> placeOrder({
    required List<CartItem> cartItems,
    required String restaurantName,
    required double totalAmount,
    required String deliveryAddress,
  }) {
    final itemsData = cartItems.map((item) {
      return serializers.serializeWith(CartItem.serializer, item)
      as Map<String, dynamic>;
    }).toList();

    return repository.firestore.placeOrder(
      items: itemsData,
      totalAmount: totalAmount,
      deliveryAddress: deliveryAddress,
    );
  }
  void updateSearch(String query) {
    _updateState(searchQuery: query.toLowerCase());
  }

  List<Restaurant> get filteredRestaurants {
    if (state.searchQuery.isEmpty) return state.restaurants.toList();
    return state.restaurants.where((r) =>
    r.name.toLowerCase().contains(state.searchQuery) ||
        r.cuisine.toLowerCase().contains(state.searchQuery)).toList();
  }

  void _loadOrders() {
    _ordersSubscription?.cancel();
    _ordersSubscription = repository.firestore.getOrders().listen((orders) {
      _updateState(orders: orders);
    });
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}


final List<Restaurant> _sampleRestaurants = [
  Restaurant((b) => b
    ..id = 1
    ..name = 'Burger Palace'
    ..cuisine = 'American'
    ..imageUrl = 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400'
    ..rating = 4.5
    ..deliveryTime = '20-30 min'
    ..deliveryFee = 29.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 2
    ..name = 'Pizza Heaven'
    ..cuisine = 'Italian'
    ..imageUrl = 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400'
    ..rating = 4.7
    ..deliveryTime = '25-40 min'
    ..deliveryFee = 19.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 3
    ..name = 'Sushi World'
    ..cuisine = 'Japanese'
    ..imageUrl = 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400'
    ..rating = 4.8
    ..deliveryTime = '30-45 min'
    ..deliveryFee = 49.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 4
    ..name = 'Spice Garden'
    ..cuisine = 'Indian'
    ..imageUrl = 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400'
    ..rating = 4.6
    ..deliveryTime = '25-35 min'
    ..deliveryFee = 15.0
    ..isOpen = false),
  Restaurant((b) => b
    ..id = 5
    ..name = 'Taco Fiesta'
    ..cuisine = 'Mexican'
    ..imageUrl = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400'
    ..rating = 4.3
    ..deliveryTime = '20-35 min'
    ..deliveryFee = 25.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 6
    ..name = 'Dragon Wok'
    ..cuisine = 'Chinese'
    ..imageUrl = 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400'
    ..rating = 4.4
    ..deliveryTime = '25-40 min'
    ..deliveryFee = 20.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 7
    ..name = 'The Grill House'
    ..cuisine = 'BBQ'
    ..imageUrl = 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400'
    ..rating = 4.6
    ..deliveryTime = '30-45 min'
    ..deliveryFee = 35.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 8
    ..name = 'Pasta Paradise'
    ..cuisine = 'Italian'
    ..imageUrl = 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400'
    ..rating = 4.5
    ..deliveryTime = '20-30 min'
    ..deliveryFee = 22.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 9
    ..name = 'Kerala Kitchen'
    ..cuisine = 'South Indian'
    ..imageUrl = 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=400'
    ..rating = 4.7
    ..deliveryTime = '25-40 min'
    ..deliveryFee = 10.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 10
    ..name = 'Shawarma Station'
    ..cuisine = 'Middle Eastern'
    ..imageUrl = 'https://images.unsplash.com/photo-1561651188-d207bbec4ec3?w=400'
    ..rating = 4.4
    ..deliveryTime = '15-25 min'
    ..deliveryFee = 18.0
    ..isOpen = true),
  Restaurant((b) => b
    ..id = 11
    ..name = 'Thai Orchid'
    ..cuisine = 'Thai'
    ..imageUrl = 'https://images.unsplash.com/photo-1562565652-a0d8f0c59eb4?w=400'
    ..rating = 4.5
    ..deliveryTime = '30-45 min'
    ..deliveryFee = 30.0
    ..isOpen = false),
  Restaurant((b) => b
    ..id = 12
    ..name = 'Cake & Co'
    ..cuisine = 'Bakery & Desserts'
    ..imageUrl = 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400'
    ..rating = 4.9
    ..deliveryTime = '20-30 min'
    ..deliveryFee = 15.0
    ..isOpen = true),
];

final List<FoodItem> _sampleFoodItems = [
  FoodItem((b) => b
    ..id = 101 ..restaurantId = 1
    ..name = 'Classic Cheeseburger'
    ..description = 'Juicy beef patty with cheddar, lettuce, tomato & special sauce'
    ..price = 199.0
    ..imageUrl = 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300'
    ..category = 'Burgers' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 102 ..restaurantId = 1
    ..name = 'Double Smash Burger'
    ..description = 'Two smashed patties, american cheese, pickles & mustard'
    ..price = 279.0
    ..imageUrl = 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=300'
    ..category = 'Burgers' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 103 ..restaurantId = 1
    ..name = 'Crispy Chicken Burger'
    ..description = 'Crispy fried chicken with coleslaw and honey mustard'
    ..price = 229.0
    ..imageUrl = 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=300'
    ..category = 'Chicken' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 104 ..restaurantId = 1
    ..name = 'Loaded Fries'
    ..description = 'Crispy fries topped with cheese sauce, bacon & jalapeños'
    ..price = 129.0
    ..imageUrl = 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=300'
    ..category = 'Sides' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 105 ..restaurantId = 1
    ..name = 'Chocolate Milkshake'
    ..description = 'Thick creamy chocolate milkshake with whipped cream'
    ..price = 99.0
    ..imageUrl = 'https://images.unsplash.com/photo-1541658016709-82535e94bc69?w=300'
    ..category = 'Drinks' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 106 ..restaurantId = 1
    ..name = 'BBQ Bacon Burger'
    ..description = 'Smoky BBQ sauce, crispy bacon, caramelized onions & cheddar'
    ..price = 249.0
    ..imageUrl = 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=300'
    ..category = 'Burgers' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 107 ..restaurantId = 1
    ..name = 'Onion Rings'
    ..description = 'Golden crispy onion rings with dipping sauce'
    ..price = 89.0
    ..imageUrl = 'https://images.unsplash.com/photo-1639024471283-03518883512d?w=300'
    ..category = 'Sides' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 201 ..restaurantId = 2
    ..name = 'Margherita Pizza'
    ..description = 'Classic tomato sauce, fresh mozzarella & basil on thin crust'
    ..price = 249.0
    ..imageUrl = 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=300'
    ..category = 'Pizza' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 202 ..restaurantId = 2
    ..name = 'Pepperoni Pizza'
    ..description = 'Loaded with premium pepperoni and mozzarella cheese'
    ..price = 299.0
    ..imageUrl = 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=300'
    ..category = 'Pizza' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 203 ..restaurantId = 2
    ..name = 'BBQ Chicken Pizza'
    ..description = 'Tangy BBQ sauce, grilled chicken, red onion & mozzarella'
    ..price = 329.0
    ..imageUrl = 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=300'
    ..category = 'Pizza' ..isAvailable = true),
  // FoodItem((b) => b
  //   ..id = 204 ..restaurantId = 2
  //   ..name = 'Garlic Bread'
  //   ..description = 'Toasted ciabatta with herb garlic butter'
  //   ..price = 89.0
  //  ..imageUrl = 'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=300'
   //  ..category = 'Sides' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 205 ..restaurantId = 2
    ..name = 'Four Cheese Pizza'
    ..description = 'Mozzarella, cheddar, parmesan & gorgonzola on creamy base'
    ..price = 349.0
    ..imageUrl = 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300'
    ..category = 'Pizza' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 206 ..restaurantId = 2
    ..name = 'Tiramisu'
    ..description = 'Classic Italian dessert with mascarpone & espresso'
    ..price = 149.0
    ..imageUrl = 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=300'
    ..category = 'Desserts' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 301 ..restaurantId = 3
    ..name = 'Salmon Nigiri (8 pcs)'
    ..description = 'Premium fresh Atlantic salmon over seasoned sushi rice'
    ..price = 349.0
    ..imageUrl = 'https://unsplash.com/photos/sushi-on-wooden-platter-5KS7T3Gs3CA'
    ..category = 'Nigiri' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 302 ..restaurantId = 3
    ..name = 'Dragon Roll'
    ..description = 'Shrimp tempura, cucumber topped with avocado & eel sauce'
    ..price = 429.0
    ..imageUrl = 'https://images.unsplash.com/photo-1562802378-063ec186a863?w=300'
    ..category = 'Rolls' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 303 ..restaurantId = 3
    ..name = 'Miso Soup'
    ..description = 'Traditional Japanese miso soup with tofu & wakame'
    ..price = 79.0
    ..imageUrl = 'https://images.unsplash.com/photo-1547592180-85f173990554?w=300'
    ..category = 'Soups' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 304 ..restaurantId = 3
    ..name = 'Tuna Sashimi (6 pcs)'
    ..description = 'Fresh premium bluefin tuna sliced to perfection'
    ..price = 399.0
    ..imageUrl = 'https://images.unsplash.com/photo-1534482421-64566f976cfa?w=300'
    ..category = 'Sashimi' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 305 ..restaurantId = 3
    ..name = 'Rainbow Roll'
    ..description = 'California roll topped with assorted fresh fish & avocado'
    ..price = 469.0
    ..imageUrl = 'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=300'
    ..category = 'Rolls' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 306 ..restaurantId = 3
    ..name = 'Edamame'
    ..description = 'Steamed salted soybeans — perfect starter'
    ..price = 99.0
    ..imageUrl = 'https://images.unsplash.com/photo-1615361200141-f45040f367be?w=300'
    ..category = 'Starters' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 401 ..restaurantId = 4
    ..name = 'Butter Chicken'
    ..description = 'Tender chicken in a rich, creamy tomato-based sauce'
    ..price = 279.0
    ..imageUrl = 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=300'
    ..category = 'Mains' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 402 ..restaurantId = 4
    ..name = 'Garlic Naan'
    ..description = 'Fluffy leavened bread baked in tandoor with garlic butter'
    ..price = 49.0
    ..imageUrl = 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=300'
    ..category = 'Breads' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 403 ..restaurantId = 4
    ..name = 'Paneer Tikka'
    ..description = 'Marinated cottage cheese grilled in tandoor with spices'
    ..price = 229.0
    ..imageUrl = 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=300'
    ..category = 'Starters' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 404 ..restaurantId = 4
    ..name = 'Biryani'
    ..description = 'Fragrant basmati rice cooked with spiced chicken & saffron'
    ..price = 319.0
    ..imageUrl = 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300'
    ..category = 'Mains' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 405 ..restaurantId = 4
    ..name = 'Gulab Jamun'
    ..description = 'Soft milk solid dumplings soaked in rose flavored sugar syrup'
    ..price = 89.0
    ..imageUrl = 'https://images.unsplash.com/photo-1601303516534-bf4bc5687d3e?w=300'
    ..category = 'Desserts' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 501 ..restaurantId = 5
    ..name = 'Chicken Tacos (3 pcs)'
    ..description = 'Grilled chicken, pico de gallo, guacamole in soft tortilla'
    ..price = 199.0
    ..imageUrl = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=300'
    ..category = 'Tacos' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 502 ..restaurantId = 5
    ..name = 'Beef Burrito'
    ..description = 'Seasoned beef, rice, beans, cheese wrapped in flour tortilla'
    ..price = 249.0
    ..imageUrl = 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=300'
    ..category = 'Burritos' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 503 ..restaurantId = 5
    ..name = 'Nachos Supreme'
    ..description = 'Tortilla chips with cheese, jalapeños, sour cream & salsa'
    ..price = 179.0
    ..imageUrl = 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=300'
    ..category = 'Sides' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 504 ..restaurantId = 5
    ..name = 'Quesadilla'
    ..description = 'Grilled flour tortilla with melted cheese & chicken'
    ..price = 219.0
    ..imageUrl = 'https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=300'
    ..category = 'Mains' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 505 ..restaurantId = 5
    ..name = 'Churros'
    ..description = 'Crispy fried dough sticks with cinnamon sugar & chocolate dip'
    ..price = 119.0
    ..imageUrl = 'https://unsplash.com/photos/a-plate-of-churros-next-to-a-cup-of-coffee-ZO606MdzJi0'
    ..category = 'Desserts' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 601 ..restaurantId = 6
    ..name = 'Kung Pao Chicken'
    ..description = 'Spicy stir-fried chicken with peanuts, vegetables & chili'
    ..price = 249.0
    ..imageUrl = 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=300'
    ..category = 'Mains' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 602 ..restaurantId = 6
    ..name = 'Dim Sum Basket (6 pcs)'
    ..description = 'Steamed pork & prawn dumplings with soy dipping sauce'
    ..price = 199.0
    ..imageUrl = 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=300'
    ..category = 'Starters' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 603 ..restaurantId = 6
    ..name = 'Fried Rice'
    ..description = 'Wok-tossed rice with egg, vegetables & soy sauce'
    ..price = 179.0
    ..imageUrl = 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=300'
    ..category = 'Rice' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 604 ..restaurantId = 6
    ..name = 'Hakka Noodles'
    ..description = 'Stir-fried noodles with vegetables, soy & chili sauce'
    ..price = 169.0
    ..imageUrl = 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300'
    ..category = 'Noodles' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 605 ..restaurantId = 6
    ..name = 'Spring Rolls (4 pcs)'
    ..description = 'Crispy fried rolls with cabbage, carrot & glass noodle filling'
    ..price = 129.0
    ..imageUrl = 'https://unsplash.com/photos/a-plate-of-food-5wWAIfnx1rM'
    ..category = 'Starters' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 701 ..restaurantId = 7
    ..name = 'Ribeye Steak'
    ..description = '300g prime ribeye grilled to perfection with herb butter'
    ..price = 699.0
    ..imageUrl = 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300'
    ..category = 'Steaks' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 702 ..restaurantId = 7
    ..name = 'BBQ Ribs Half Rack'
    ..description = 'Slow-cooked pork ribs glazed with smoky BBQ sauce'
    ..price = 549.0
    ..imageUrl = 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300'
    ..category = 'BBQ' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 703 ..restaurantId = 7
    ..name = 'Grilled Corn'
    ..description = 'Chargrilled sweet corn with butter, lime & chili flakes'
    ..price = 79.0
    ..imageUrl = 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=300'
    ..category = 'Sides' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 704 ..restaurantId = 7
    ..name = 'Grilled Chicken Platter'
    ..description = 'Half chicken marinated in herbs & grilled over charcoal'
    ..price = 399.0
    ..imageUrl = 'https://images.unsplash.com/photo-1598103442097-8b74394b95c1?w=300'
    ..category = 'Grills' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 801 ..restaurantId = 8
    ..name = 'Spaghetti Carbonara'
    ..description = 'Creamy egg sauce, pancetta, parmesan & black pepper'
    ..price = 279.0
    ..imageUrl = 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=300'
    ..category = 'Pasta' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 802 ..restaurantId = 8
    ..name = 'Penne Arrabbiata'
    ..description = 'Penne in spicy tomato sauce with garlic & fresh basil'
    ..price = 229.0
    ..imageUrl = 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=300'
    ..category = 'Pasta' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 803 ..restaurantId = 8
    ..name = 'Lasagna'
    ..description = 'Layered pasta with beef bolognese, béchamel & parmesan'
    ..price = 319.0
    ..imageUrl = 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=300'
    ..category = 'Baked' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 804 ..restaurantId = 8
    ..name = 'Caesar Salad'
    ..description = 'Romaine lettuce, croutons, parmesan with classic Caesar dressing'
    ..price = 179.0
    ..imageUrl = 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=300'
    ..category = 'Salads' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 805 ..restaurantId = 8
    ..name = 'Panna Cotta'
    ..description = 'Silky Italian cream dessert with berry coulis'
    ..price = 149.0
    ..imageUrl = 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300'
    ..category = 'Desserts' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 901 ..restaurantId = 9
    ..name = 'Kerala Fish Curry'
    ..description = 'Fresh fish cooked in coconut milk with raw mango & spices'
    ..price = 289.0
    ..imageUrl = 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=300'
    ..category = 'Curries' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 902 ..restaurantId = 9
    ..name = 'Appam & Stew'
    ..description = 'Lacy rice hoppers served with coconut vegetable stew'
    ..price = 149.0
    ..imageUrl = 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300'
    ..category = 'Breakfast' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 903 ..restaurantId = 9
    ..name = 'Prawn Moilee'
    ..description = 'Tiger prawns in light golden coconut milk curry'
    ..price = 349.0
    ..imageUrl = 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300'
    ..category = 'Seafood' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 904 ..restaurantId = 9
    ..name = 'Puttu & Kadala Curry'
    ..description = 'Steamed rice cake cylinders with black chickpea coconut curry'
    ..price = 119.0
    ..imageUrl = 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300'
    ..category = 'Breakfast' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 905 ..restaurantId = 9
    ..name = 'Donut'
    ..description = 'Traditional Kerala dessert with rice, jaggery & coconut milk'
    ..price = 89.0
    ..imageUrl = 'https://unsplash.com/photos/doughnut-with-toppings-q54Oxq44MZs'
    ..category = 'Desserts' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1001 ..restaurantId = 10
    ..name = 'Chicken Shawarma'
    ..description = 'Marinated chicken with garlic sauce, pickles in warm pita'
    ..price = 149.0
    ..imageUrl = 'https://images.unsplash.com/photo-1561651188-d207bbec4ec3?w=300'
    ..category = 'Shawarma' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1002 ..restaurantId = 10
    ..name = 'Falafel Wrap'
    ..description = 'Crispy falafel, hummus, tabouleh & tahini in flatbread'
    ..price = 129.0
    ..imageUrl = 'https://images.unsplash.com/photo-1593001872095-7d5b3868fb1d?w=300'
    ..category = 'Wraps' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1003 ..restaurantId = 10
    ..name = 'Hummus Plate'
    ..description = 'Creamy hummus with olive oil, paprika & warm pita bread'
    ..price = 99.0
    ..imageUrl = 'https://images.unsplash.com/photo-1577805947697-89e18249d767?w=300'
    ..category = 'Sides' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1004 ..restaurantId = 10
    ..name = 'Mixed Grill Platter'
    ..description = 'Assorted grilled meats — chicken, lamb & beef with dips'
    ..price = 399.0
    ..imageUrl = 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300'
    ..category = 'Platters' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1101 ..restaurantId = 11
    ..name = 'Pad Thai'
    ..description = 'Stir-fried rice noodles with egg, peanuts, bean sprouts & lime'
    ..price = 239.0
    ..imageUrl = 'https://images.unsplash.com/photo-1562565652-a0d8f0c59eb4?w=300'
    ..category = 'Noodles' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1102 ..restaurantId = 11
    ..name = 'Green Curry'
    ..description = 'Coconut milk curry with chicken, Thai basil & green chilies'
    ..price = 269.0
    ..imageUrl = 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=300'
    ..category = 'Curries' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1103 ..restaurantId = 11
    ..name = 'Tom Yum Soup'
    ..description = 'Hot & sour prawn soup with lemongrass, kaffir lime & galangal'
    ..price = 179.0
    ..imageUrl = 'https://images.unsplash.com/photo-1547592180-85f173990554?w=300'
    ..category = 'Soups' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1104 ..restaurantId = 11
    ..name = 'Mango Sticky Rice'
    ..description = 'Sweet glutinous rice with fresh mango & coconut cream'
    ..price = 149.0
    ..imageUrl = 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300'
    ..category = 'Desserts' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1201 ..restaurantId = 12
    ..name = 'Chocolate Lava Cake'
    ..description = 'Warm chocolate cake with molten center, served with ice cream'
    ..price = 179.0
    ..imageUrl = 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=300'
    ..category = 'Cakes' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1202 ..restaurantId = 12
    ..name = 'Blueberry Cheesecake'
    ..description = 'Creamy NY style cheesecake with fresh blueberry topping'
    ..price = 199.0
    ..imageUrl = 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=300'
    ..category = 'Cakes' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1203 ..restaurantId = 12
    ..name = 'Croissant'
    ..description = 'Buttery flaky French croissant, freshly baked every morning'
    ..price = 79.0
    ..imageUrl = 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=300'
    ..category = 'Bakery' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1204 ..restaurantId = 12
    ..name = 'Cinnamon Roll'
    ..description = 'Soft warm roll with cinnamon sugar & cream cheese frosting'
    ..price = 99.0
    ..imageUrl = 'https://images.unsplash.com/photo-1509365465985-25d11c17e812?w=300'
    ..category = 'Bakery' ..isAvailable = true),
  FoodItem((b) => b
    ..id = 1205 ..restaurantId = 12
    ..name = 'Cappuccino'
    ..description = 'Rich espresso with steamed milk foam & light dusting of cocoa'
    ..price = 89.0
    ..imageUrl = 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=300'
    ..category = 'Drinks' ..isAvailable = true),
];
