// lib/model/order.dart
library order;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'cart_item.dart';

part 'order.g.dart';

abstract class Order implements Built<Order, OrderBuilder> {
  int get id;
  String get restaurantName;
  BuiltList<CartItem> get items;
  double get totalAmount;
  String get status; // 'placed', 'preparing', 'on_the_way', 'delivered'
  DateTime get placedAt;
  String get deliveryAddress;

  Order._();
  factory Order([void Function(OrderBuilder) updates]) = _$Order;

  static Serializer<Order> get serializer => _$orderSerializer;
}
