// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Restaurant> _$restaurantSerializer = _$RestaurantSerializer();

class _$RestaurantSerializer implements StructuredSerializer<Restaurant> {
  @override
  final Iterable<Type> types = const [Restaurant, _$Restaurant];
  @override
  final String wireName = 'Restaurant';

  @override
  Iterable<Object?> serialize(Serializers serializers, Restaurant object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'cuisine',
      serializers.serialize(object.cuisine,
          specifiedType: const FullType(String)),
      'imageUrl',
      serializers.serialize(object.imageUrl,
          specifiedType: const FullType(String)),
      'rating',
      serializers.serialize(object.rating,
          specifiedType: const FullType(double)),
      'deliveryTime',
      serializers.serialize(object.deliveryTime,
          specifiedType: const FullType(String)),
      'deliveryFee',
      serializers.serialize(object.deliveryFee,
          specifiedType: const FullType(double)),
      'isOpen',
      serializers.serialize(object.isOpen, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Restaurant deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = RestaurantBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'cuisine':
          result.cuisine = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'imageUrl':
          result.imageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'rating':
          result.rating = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'deliveryTime':
          result.deliveryTime = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'deliveryFee':
          result.deliveryFee = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'isOpen':
          result.isOpen = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Restaurant extends Restaurant {
  @override
  final int id;
  @override
  final String name;
  @override
  final String cuisine;
  @override
  final String imageUrl;
  @override
  final double rating;
  @override
  final String deliveryTime;
  @override
  final double deliveryFee;
  @override
  final bool isOpen;

  factory _$Restaurant([void Function(RestaurantBuilder)? updates]) =>
      (RestaurantBuilder()..update(updates))._build();

  _$Restaurant._(
      {required this.id,
      required this.name,
      required this.cuisine,
      required this.imageUrl,
      required this.rating,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.isOpen})
      : super._();
  @override
  Restaurant rebuild(void Function(RestaurantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RestaurantBuilder toBuilder() => RestaurantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Restaurant &&
        id == other.id &&
        name == other.name &&
        cuisine == other.cuisine &&
        imageUrl == other.imageUrl &&
        rating == other.rating &&
        deliveryTime == other.deliveryTime &&
        deliveryFee == other.deliveryFee &&
        isOpen == other.isOpen;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, cuisine.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, deliveryTime.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, isOpen.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Restaurant')
          ..add('id', id)
          ..add('name', name)
          ..add('cuisine', cuisine)
          ..add('imageUrl', imageUrl)
          ..add('rating', rating)
          ..add('deliveryTime', deliveryTime)
          ..add('deliveryFee', deliveryFee)
          ..add('isOpen', isOpen))
        .toString();
  }
}

class RestaurantBuilder implements Builder<Restaurant, RestaurantBuilder> {
  _$Restaurant? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _cuisine;
  String? get cuisine => _$this._cuisine;
  set cuisine(String? cuisine) => _$this._cuisine = cuisine;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  double? _rating;
  double? get rating => _$this._rating;
  set rating(double? rating) => _$this._rating = rating;

  String? _deliveryTime;
  String? get deliveryTime => _$this._deliveryTime;
  set deliveryTime(String? deliveryTime) => _$this._deliveryTime = deliveryTime;

  double? _deliveryFee;
  double? get deliveryFee => _$this._deliveryFee;
  set deliveryFee(double? deliveryFee) => _$this._deliveryFee = deliveryFee;

  bool? _isOpen;
  bool? get isOpen => _$this._isOpen;
  set isOpen(bool? isOpen) => _$this._isOpen = isOpen;

  RestaurantBuilder();

  RestaurantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _cuisine = $v.cuisine;
      _imageUrl = $v.imageUrl;
      _rating = $v.rating;
      _deliveryTime = $v.deliveryTime;
      _deliveryFee = $v.deliveryFee;
      _isOpen = $v.isOpen;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Restaurant other) {
    _$v = other as _$Restaurant;
  }

  @override
  void update(void Function(RestaurantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Restaurant build() => _build();

  _$Restaurant _build() {
    final _$result = _$v ??
        _$Restaurant._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Restaurant', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'Restaurant', 'name'),
          cuisine: BuiltValueNullFieldError.checkNotNull(
              cuisine, r'Restaurant', 'cuisine'),
          imageUrl: BuiltValueNullFieldError.checkNotNull(
              imageUrl, r'Restaurant', 'imageUrl'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'Restaurant', 'rating'),
          deliveryTime: BuiltValueNullFieldError.checkNotNull(
              deliveryTime, r'Restaurant', 'deliveryTime'),
          deliveryFee: BuiltValueNullFieldError.checkNotNull(
              deliveryFee, r'Restaurant', 'deliveryFee'),
          isOpen: BuiltValueNullFieldError.checkNotNull(
              isOpen, r'Restaurant', 'isOpen'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
