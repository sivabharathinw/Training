
library cart_item;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_item.g.dart';
abstract class CartItem implements Built<CartItem, CartItemBuilder> {
  int get id;
  int get foodItemId;
  String get foodItemName;
  double get price;
  String get imageUrl;
  int get quantity;
  int get restaurantId;
  String get restaurantName;

  double get totalPrice => price * quantity;

  CartItem._();
  factory CartItem([void Function(CartItemBuilder) updates]) = _$CartItem;

  static Serializer<CartItem> get serializer => _$cartItemSerializer;
}