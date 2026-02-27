import '../../model/restaurant.dart';
import '../../model/food_item.dart';
import '../../model/cart_item.dart';
import '../../model/order.dart';

abstract class LocalStorageService {
  Future<void> init();
  

  // restaurants
  Future<List<Restaurant>> getRestaurants();
  Future<void> insertRestaurant(Restaurant restaurant);
  Future<void> insertAllRestaurants(List<Restaurant> restaurants);

  // food Items
  Future<List<FoodItem>> getFoodItems(int restaurantId);
  Future<void> insertFoodItem(FoodItem item);
  Future<void> insertAllFoodItems(List<FoodItem> items);

  // cart
  Future<List<CartItem>> getCartItems();
  Future<void> addCartItem(CartItem item);
  Future<void> updateCartItemQuantity(int cartItemId, int quantity);
  Future<void> removeCartItem(int cartItemId);
  Future<void> clearCart();

  // orders
  Future<List<Order>> getOrders();
  Future<void> saveOrder(Order order);
}