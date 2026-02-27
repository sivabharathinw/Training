// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CartItem> _$cartItemSerializer = _$CartItemSerializer();

class _$CartItemSerializer implements StructuredSerializer<CartItem> {
  @override
  final Iterable<Type> types = const [CartItem, _$CartItem];
  @override
  final String wireName = 'CartItem';

  @override
  Iterable<Object?> serialize(Serializers serializers, CartItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'foodItemId',
      serializers.serialize(object.foodItemId,
          specifiedType: const FullType(int)),
      'foodItemName',
      serializers.serialize(object.foodItemName,
          specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price,
          specifiedType: const FullType(double)),
      'imageUrl',
      serializers.serialize(object.imageUrl,
          specifiedType: const FullType(String)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(int)),
      'restaurantId',
      serializers.serialize(object.restaurantId,
          specifiedType: const FullType(int)),
      'restaurantName',
      serializers.serialize(object.restaurantName,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  CartItem deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CartItemBuilder();

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
        case 'foodItemId':
          result.foodItemId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'foodItemName':
          result.foodItemName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'imageUrl':
          result.imageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'restaurantId':
          result.restaurantId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'restaurantName':
          result.restaurantName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$CartItem extends CartItem {
  @override
  final int id;
  @override
  final int foodItemId;
  @override
  final String foodItemName;
  @override
  final double price;
  @override
  final String imageUrl;
  @override
  final int quantity;
  @override
  final int restaurantId;
  @override
  final String restaurantName;

  factory _$CartItem([void Function(CartItemBuilder)? updates]) =>
      (CartItemBuilder()..update(updates))._build();

  _$CartItem._(
      {required this.id,
      required this.foodItemId,
      required this.foodItemName,
      required this.price,
      required this.imageUrl,
      required this.quantity,
      required this.restaurantId,
      required this.restaurantName})
      : super._();
  @override
  CartItem rebuild(void Function(CartItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartItemBuilder toBuilder() => CartItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartItem &&
        id == other.id &&
        foodItemId == other.foodItemId &&
        foodItemName == other.foodItemName &&
        price == other.price &&
        imageUrl == other.imageUrl &&
        quantity == other.quantity &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, foodItemId.hashCode);
    _$hash = $jc(_$hash, foodItemName.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartItem')
          ..add('id', id)
          ..add('foodItemId', foodItemId)
          ..add('foodItemName', foodItemName)
          ..add('price', price)
          ..add('imageUrl', imageUrl)
          ..add('quantity', quantity)
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName))
        .toString();
  }
}

class CartItemBuilder implements Builder<CartItem, CartItemBuilder> {
  _$CartItem? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _foodItemId;
  int? get foodItemId => _$this._foodItemId;
  set foodItemId(int? foodItemId) => _$this._foodItemId = foodItemId;

  String? _foodItemName;
  String? get foodItemName => _$this._foodItemName;
  set foodItemName(String? foodItemName) => _$this._foodItemName = foodItemName;

  double? _price;
  double? get price => _$this._price;
  set price(double? price) => _$this._price = price;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  int? _restaurantId;
  int? get restaurantId => _$this._restaurantId;
  set restaurantId(int? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  CartItemBuilder();

  CartItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _foodItemId = $v.foodItemId;
      _foodItemName = $v.foodItemName;
      _price = $v.price;
      _imageUrl = $v.imageUrl;
      _quantity = $v.quantity;
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartItem other) {
    _$v = other as _$CartItem;
  }

  @override
  void update(void Function(CartItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartItem build() => _build();

  _$CartItem _build() {
    final _$result = _$v ??
        _$CartItem._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CartItem', 'id'),
          foodItemId: BuiltValueNullFieldError.checkNotNull(
              foodItemId, r'CartItem', 'foodItemId'),
          foodItemName: BuiltValueNullFieldError.checkNotNull(
              foodItemName, r'CartItem', 'foodItemName'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'CartItem', 'price'),
          imageUrl: BuiltValueNullFieldError.checkNotNull(
              imageUrl, r'CartItem', 'imageUrl'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'CartItem', 'quantity'),
          restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId, r'CartItem', 'restaurantId'),
          restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName, r'CartItem', 'restaurantName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
