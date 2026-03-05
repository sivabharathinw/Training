// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Order> _$orderSerializer = _$OrderSerializer();

class _$OrderSerializer implements StructuredSerializer<Order> {
  @override
  final Iterable<Type> types = const [Order, _$Order];
  @override
  final String wireName = 'Order';

  @override
  Iterable<Object?> serialize(Serializers serializers, Order object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'restaurantName',
      serializers.serialize(object.restaurantName,
          specifiedType: const FullType(String)),
      'items',
      serializers.serialize(object.items,
          specifiedType:
              const FullType(BuiltList, const [const FullType(CartItem)])),
      'totalAmount',
      serializers.serialize(object.totalAmount,
          specifiedType: const FullType(double)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'placedAt',
      serializers.serialize(object.placedAt,
          specifiedType: const FullType(DateTime)),
      'deliveryAddress',
      serializers.serialize(object.deliveryAddress,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Order deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OrderBuilder();

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
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'restaurantName':
          result.restaurantName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'items':
          result.items.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(CartItem)]))!
              as BuiltList<Object?>);
          break;
        case 'totalAmount':
          result.totalAmount = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'placedAt':
          result.placedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'deliveryAddress':
          result.deliveryAddress = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Order extends Order {
  @override
  final int id;
  @override
  final String userId;
  @override
  final String restaurantName;
  @override
  final BuiltList<CartItem> items;
  @override
  final double totalAmount;
  @override
  final String status;
  @override
  final DateTime placedAt;
  @override
  final String deliveryAddress;

  factory _$Order([void Function(OrderBuilder)? updates]) =>
      (OrderBuilder()..update(updates))._build();

  _$Order._(
      {required this.id,
      required this.userId,
      required this.restaurantName,
      required this.items,
      required this.totalAmount,
      required this.status,
      required this.placedAt,
      required this.deliveryAddress})
      : super._();
  @override
  Order rebuild(void Function(OrderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderBuilder toBuilder() => OrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Order &&
        id == other.id &&
        userId == other.userId &&
        restaurantName == other.restaurantName &&
        items == other.items &&
        totalAmount == other.totalAmount &&
        status == other.status &&
        placedAt == other.placedAt &&
        deliveryAddress == other.deliveryAddress;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jc(_$hash, deliveryAddress.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Order')
          ..add('id', id)
          ..add('userId', userId)
          ..add('restaurantName', restaurantName)
          ..add('items', items)
          ..add('totalAmount', totalAmount)
          ..add('status', status)
          ..add('placedAt', placedAt)
          ..add('deliveryAddress', deliveryAddress))
        .toString();
  }
}

class OrderBuilder implements Builder<Order, OrderBuilder> {
  _$Order? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  ListBuilder<CartItem>? _items;
  ListBuilder<CartItem> get items => _$this._items ??= ListBuilder<CartItem>();
  set items(ListBuilder<CartItem>? items) => _$this._items = items;

  double? _totalAmount;
  double? get totalAmount => _$this._totalAmount;
  set totalAmount(double? totalAmount) => _$this._totalAmount = totalAmount;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  String? _deliveryAddress;
  String? get deliveryAddress => _$this._deliveryAddress;
  set deliveryAddress(String? deliveryAddress) =>
      _$this._deliveryAddress = deliveryAddress;

  OrderBuilder();

  OrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _restaurantName = $v.restaurantName;
      _items = $v.items.toBuilder();
      _totalAmount = $v.totalAmount;
      _status = $v.status;
      _placedAt = $v.placedAt;
      _deliveryAddress = $v.deliveryAddress;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Order other) {
    _$v = other as _$Order;
  }

  @override
  void update(void Function(OrderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Order build() => _build();

  _$Order _build() {
    _$Order _$result;
    try {
      _$result = _$v ??
          _$Order._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Order', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'Order', 'userId'),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
                restaurantName, r'Order', 'restaurantName'),
            items: items.build(),
            totalAmount: BuiltValueNullFieldError.checkNotNull(
                totalAmount, r'Order', 'totalAmount'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Order', 'status'),
            placedAt: BuiltValueNullFieldError.checkNotNull(
                placedAt, r'Order', 'placedAt'),
            deliveryAddress: BuiltValueNullFieldError.checkNotNull(
                deliveryAddress, r'Order', 'deliveryAddress'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Order', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
