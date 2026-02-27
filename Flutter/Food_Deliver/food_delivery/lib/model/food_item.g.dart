// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FoodItem> _$foodItemSerializer = _$FoodItemSerializer();

class _$FoodItemSerializer implements StructuredSerializer<FoodItem> {
  @override
  final Iterable<Type> types = const [FoodItem, _$FoodItem];
  @override
  final String wireName = 'FoodItem';

  @override
  Iterable<Object?> serialize(Serializers serializers, FoodItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'restaurantId',
      serializers.serialize(object.restaurantId,
          specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price,
          specifiedType: const FullType(double)),
      'imageUrl',
      serializers.serialize(object.imageUrl,
          specifiedType: const FullType(String)),
      'category',
      serializers.serialize(object.category,
          specifiedType: const FullType(String)),
      'isAvailable',
      serializers.serialize(object.isAvailable,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  FoodItem deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = FoodItemBuilder();

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
        case 'restaurantId':
          result.restaurantId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
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
        case 'category':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isAvailable':
          result.isAvailable = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$FoodItem extends FoodItem {
  @override
  final int id;
  @override
  final int restaurantId;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  final String imageUrl;
  @override
  final String category;
  @override
  final bool isAvailable;

  factory _$FoodItem([void Function(FoodItemBuilder)? updates]) =>
      (FoodItemBuilder()..update(updates))._build();

  _$FoodItem._(
      {required this.id,
      required this.restaurantId,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.category,
      required this.isAvailable})
      : super._();
  @override
  FoodItem rebuild(void Function(FoodItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FoodItemBuilder toBuilder() => FoodItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FoodItem &&
        id == other.id &&
        restaurantId == other.restaurantId &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        imageUrl == other.imageUrl &&
        category == other.category &&
        isAvailable == other.isAvailable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, isAvailable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FoodItem')
          ..add('id', id)
          ..add('restaurantId', restaurantId)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('imageUrl', imageUrl)
          ..add('category', category)
          ..add('isAvailable', isAvailable))
        .toString();
  }
}

class FoodItemBuilder implements Builder<FoodItem, FoodItemBuilder> {
  _$FoodItem? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _restaurantId;
  int? get restaurantId => _$this._restaurantId;
  set restaurantId(int? restaurantId) => _$this._restaurantId = restaurantId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  double? _price;
  double? get price => _$this._price;
  set price(double? price) => _$this._price = price;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  bool? _isAvailable;
  bool? get isAvailable => _$this._isAvailable;
  set isAvailable(bool? isAvailable) => _$this._isAvailable = isAvailable;

  FoodItemBuilder();

  FoodItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _restaurantId = $v.restaurantId;
      _name = $v.name;
      _description = $v.description;
      _price = $v.price;
      _imageUrl = $v.imageUrl;
      _category = $v.category;
      _isAvailable = $v.isAvailable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FoodItem other) {
    _$v = other as _$FoodItem;
  }

  @override
  void update(void Function(FoodItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FoodItem build() => _build();

  _$FoodItem _build() {
    final _$result = _$v ??
        _$FoodItem._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FoodItem', 'id'),
          restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId, r'FoodItem', 'restaurantId'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'FoodItem', 'name'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'FoodItem', 'description'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'FoodItem', 'price'),
          imageUrl: BuiltValueNullFieldError.checkNotNull(
              imageUrl, r'FoodItem', 'imageUrl'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'FoodItem', 'category'),
          isAvailable: BuiltValueNullFieldError.checkNotNull(
              isAvailable, r'FoodItem', 'isAvailable'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
