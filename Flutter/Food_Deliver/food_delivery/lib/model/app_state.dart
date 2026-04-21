
library app_state;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import 'restaurant.dart';
import 'food_item.dart';
import 'cart_item.dart';
import 'order.dart';
import 'user_profile.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<Restaurant> get restaurants;
  BuiltList<FoodItem> get menuItems;
  BuiltList<CartItem> get cartItems;
  BuiltList<Order> get orders;
  String get searchQuery;
  UserProfile? get currentUser;

  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get itemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  AppState._();
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;
}