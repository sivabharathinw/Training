// lib/model/order.dart
library order;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'cart_item.dart';

part 'order.g.dart';

abstract class Order implements Built<Order, OrderBuilder> {
  int get id;
  String get userId;
  String get restaurantName;
  BuiltList<CartItem> get items;
  double get totalAmount;
  String get status;
  // FIX: stored as ISO8601 String so built_value serializer can handle it
  String get placedAt;
  String get deliveryAddress;

  // Convenience getter to parse placedAt string back to DateTime when needed in UI
  DateTime get placedAtDate => DateTime.tryParse(placedAt) ?? DateTime.now();

  Order._();
  factory Order([void Function(OrderBuilder) updates]) = _$Order;

  static Serializer<Order> get serializer => _$orderSerializer;
}