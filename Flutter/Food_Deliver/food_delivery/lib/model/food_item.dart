// lib/model/food_item.dart
library food_item;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'food_item.g.dart';

abstract class FoodItem implements Built<FoodItem, FoodItemBuilder> {
  int get id;
  int get restaurantId;
  String get name;
  String get description;
  double get price;
  String get imageUrl;
  String get category;
  bool get isAvailable;

  FoodItem._();

  factory FoodItem([void Function(FoodItemBuilder) updates]) = _$FoodItem;

  static Serializer<FoodItem> get serializer => _$foodItemSerializer;
}
