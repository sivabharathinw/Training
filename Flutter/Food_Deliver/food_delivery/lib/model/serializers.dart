// lib/model/serializers.dart
library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'restaurant.dart';
import 'food_item.dart';
import 'cart_item.dart';
import 'order.dart';

part 'serializers.g.dart';

@SerializersFor([
  Restaurant,
  FoodItem,
  CartItem,
  Order,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin()))
    .build();
