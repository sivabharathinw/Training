// lib/model/restaurant.dart
library restaurant;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'restaurant.g.dart';

abstract class Restaurant implements Built<Restaurant, RestaurantBuilder> {
  int get id;
  String get name;
  String get cuisine;
  String get imageUrl;
  double get rating;
  String get deliveryTime;
  double get deliveryFee;
  bool get isOpen;

  Restaurant._();
  factory Restaurant([void Function(RestaurantBuilder) updates]) = _$Restaurant;


  static Serializer<Restaurant> get serializer => _$restaurantSerializer;
}
