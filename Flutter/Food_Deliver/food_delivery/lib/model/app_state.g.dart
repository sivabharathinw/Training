// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final BuiltList<Restaurant> restaurants;
  @override
  final BuiltList<FoodItem> menuItems;
  @override
  final BuiltList<CartItem> cartItems;
  @override
  final BuiltList<Order> orders;
  @override
  final String searchQuery;
  @override
  final bool isLoading;

  factory _$AppState([void Function(AppStateBuilder)? updates]) =>
      (AppStateBuilder()..update(updates))._build();

  _$AppState._(
      {required this.restaurants,
      required this.menuItems,
      required this.cartItems,
      required this.orders,
      required this.searchQuery,
      required this.isLoading})
      : super._();
  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        restaurants == other.restaurants &&
        menuItems == other.menuItems &&
        cartItems == other.cartItems &&
        orders == other.orders &&
        searchQuery == other.searchQuery &&
        isLoading == other.isLoading;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, menuItems.hashCode);
    _$hash = $jc(_$hash, cartItems.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, searchQuery.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppState')
          ..add('restaurants', restaurants)
          ..add('menuItems', menuItems)
          ..add('cartItems', cartItems)
          ..add('orders', orders)
          ..add('searchQuery', searchQuery)
          ..add('isLoading', isLoading))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState? _$v;

  ListBuilder<Restaurant>? _restaurants;
  ListBuilder<Restaurant> get restaurants =>
      _$this._restaurants ??= ListBuilder<Restaurant>();
  set restaurants(ListBuilder<Restaurant>? restaurants) =>
      _$this._restaurants = restaurants;

  ListBuilder<FoodItem>? _menuItems;
  ListBuilder<FoodItem> get menuItems =>
      _$this._menuItems ??= ListBuilder<FoodItem>();
  set menuItems(ListBuilder<FoodItem>? menuItems) =>
      _$this._menuItems = menuItems;

  ListBuilder<CartItem>? _cartItems;
  ListBuilder<CartItem> get cartItems =>
      _$this._cartItems ??= ListBuilder<CartItem>();
  set cartItems(ListBuilder<CartItem>? cartItems) =>
      _$this._cartItems = cartItems;

  ListBuilder<Order>? _orders;
  ListBuilder<Order> get orders => _$this._orders ??= ListBuilder<Order>();
  set orders(ListBuilder<Order>? orders) => _$this._orders = orders;

  String? _searchQuery;
  String? get searchQuery => _$this._searchQuery;
  set searchQuery(String? searchQuery) => _$this._searchQuery = searchQuery;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  AppStateBuilder();

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurants = $v.restaurants.toBuilder();
      _menuItems = $v.menuItems.toBuilder();
      _cartItems = $v.cartItems.toBuilder();
      _orders = $v.orders.toBuilder();
      _searchQuery = $v.searchQuery;
      _isLoading = $v.isLoading;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppState build() => _build();

  _$AppState _build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          _$AppState._(
            restaurants: restaurants.build(),
            menuItems: menuItems.build(),
            cartItems: cartItems.build(),
            orders: orders.build(),
            searchQuery: BuiltValueNullFieldError.checkNotNull(
                searchQuery, r'AppState', 'searchQuery'),
            isLoading: BuiltValueNullFieldError.checkNotNull(
                isLoading, r'AppState', 'isLoading'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'menuItems';
        menuItems.build();
        _$failedField = 'cartItems';
        cartItems.build();
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
