import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:built_collection/built_collection.dart';
import '../model/serializers.dart';

import '../core/services/local_storage_service.dart';
import '../model/restaurant.dart';
import '../model/food_item.dart';
import '../model/cart_item.dart';
import '../model/order.dart';

class LocalStorageServiceImpl implements LocalStorageService {
  static Database? _db;

  @override
  Future<void> init() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'food_delivery.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    // table for restaurant — camelCase to match serializer output
    await db.execute('''
      CREATE TABLE restaurants (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        cuisine TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        rating REAL NOT NULL,
        deliveryTime TEXT NOT NULL,
        deliveryFee REAL NOT NULL,
        isOpen INTEGER NOT NULL
      )
    ''');

    // table for food Items — camelCase to match serializer output
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY,
        restaurantId INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        category TEXT NOT NULL,
        isAvailable INTEGER NOT NULL,
        FOREIGN KEY (restaurantId) REFERENCES restaurants (id)
      )
    ''');

    // table for Cart Items — camelCase to match serializer output
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        foodItemId INTEGER NOT NULL,
        foodItemName TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        restaurantId INTEGER NOT NULL,
        restaurantName TEXT NOT NULL
      )
    ''');

    // table for Orders
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_name TEXT NOT NULL,
        items_json TEXT NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT NOT NULL,
        placed_at TEXT NOT NULL,
        delivery_address TEXT NOT NULL
      )
    ''');
  }

  Database get _database {
    if (_db == null) throw Exception('Database not initialized.');
    return _db!;
  }

  @override
  Future<List<Restaurant>> getRestaurants() async {
    final rows = await _database.query('restaurants');
    return rows.map(_rowToRestaurant).toList();
  }

  @override
  Future<void> insertRestaurant(Restaurant restaurant) async {
    await _database.insert(
      'restaurants',
      _restaurantToRow(restaurant),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertAllRestaurants(List<Restaurant> restaurants) async {
    final batch = _database.batch();
    for (final r in restaurants) {
      batch.insert(
        'restaurants',
        _restaurantToRow(r),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<FoodItem>> getFoodItems(int restaurantId) async {
    final rows = await _database.query(
      'food_items',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
    );
    return rows.map(_rowToFoodItem).toList();
  }

  @override
  Future<void> insertFoodItem(FoodItem item) async {
    await _database.insert(
      'food_items',
      _foodItemToRow(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertAllFoodItems(List<FoodItem> items) async {
    final batch = _database.batch();
    for (final item in items) {
      batch.insert(
        'food_items',
        _foodItemToRow(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    final rows = await _database.query('cart_items');
    return rows.map(_rowToCartItem).toList();
  }

  @override
  Future<void> addCartItem(CartItem item) async {
    final existing = await _database.query(
      'cart_items',
      where: 'foodItemId = ?', // if briyani id is 1 and we add briyani again then it will update the quantity instead of adding new row
      whereArgs: [item.foodItemId],
    );
    if (existing.isNotEmpty) {
      final currentQty = existing.first['quantity'] as int;
      await _database.update(
        'cart_items',
        {'quantity': currentQty + 1},
        where: 'foodItemId = ?',
        whereArgs: [item.foodItemId],
      );
    } else {
      await _database.insert('cart_items', {
        'foodItemId': item.foodItemId,
        'foodItemName': item.foodItemName,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'quantity': item.quantity,
        'restaurantId': item.restaurantId,
        'restaurantName': item.restaurantName,
      });
    }
  }

  @override
  Future<void> updateCartItemQuantity(int cartItemId, int quantity) async {
    await _database.update(
      'cart_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    await _database.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  @override
  Future<void> clearCart() async {
    await _database.delete('cart_items');
  }

  // @override
  // Future<List<Order>> getOrders() async {
  //   final rows = await _database.query('orders', orderBy: 'id DESC');
  //   return rows.map(_rowToOrder).toList();
  // }

  // @override
  // Future<void> saveOrder(Order order) async {
  //   await _database.insert(
  //     'orders',
  //     _orderToRow(order),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Map<String, dynamic> _orderToRow(Order order) {
  //   final itemsJson = jsonEncode(
  //     order.items.map((item) {
  //       return serializers.serializeWith(
  //         CartItem.serializer,
  //         item,
  //       );
  //     }).toList(),
  //   );
  //
  //   return {
  //     'id': order.id,
  //     'restaurant_name': order.restaurantName,
  //     'items_json': itemsJson,
  //     'total_amount': order.totalAmount,
  //     'status': order.status,
  //     'placed_at': order.placedAt.toIso8601String(),
  //     'delivery_address': order.deliveryAddress,
  //   };
  // }
  //
  // Order _rowToOrder(Map<String, dynamic> row) {
  //   // Decode JSON string from database
  //   final itemsRaw = jsonDecode(row['items_json'] as String) as List;
  //
  //   // Convert each JSON map → CartItem using serializer
  //   final items = itemsRaw.map((itemJson) {
  //     return serializers.deserializeWith(
  //       CartItem.serializer,
  //       itemJson,
  //     )!;
  //   }).toList();
  //
  //   // Build Order object
  //   return Order((b) => b
  //     ..id = row['id'] as int
  //     ..restaurantName = row['restaurant_name'] as String
  //     ..items.replace(items)
  //     ..totalAmount = (row['total_amount'] as num).toDouble()
  //     ..status = row['status'] as String
  //     ..placedAt = DateTime.parse(row['placed_at'] as String)
  //     ..deliveryAddress = row['delivery_address'] as String);
  // }

  Map<String, dynamic> _restaurantToRow(Restaurant r) {
    final json = serializers.serializeWith(
      Restaurant.serializer,
      r,
    ) as Map<String, dynamic>;

    // serializer gives isOpen as bool, SQLite needs int
    return {
      ...json,
      'isOpen': r.isOpen ? 1 : 0,
    };
  }

  Restaurant _rowToRestaurant(Map<String, dynamic> row) {
    // isOpen stored as int in SQLite, serializer needs bool
    final normalizedRow = {
      ...row,
      'isOpen': (row['isOpen'] as int) == 1,
    };

    return serializers.deserializeWith(
      Restaurant.serializer,
      normalizedRow,
    )!;
  }

  Map<String, dynamic> _foodItemToRow(FoodItem item) {
    final json = serializers.serializeWith(
      FoodItem.serializer,
      item,
    ) as Map<String, dynamic>;

    // serializer gives isAvailable as bool, SQLite needs int
    return {
      ...json,
      'isAvailable': item.isAvailable ? 1 : 0,
    };
  }

  FoodItem _rowToFoodItem(Map<String, dynamic> row) {
    // isAvailable stored as int in SQLite, serializer needs bool
    final normalizedRow = {
      ...row,
      'isAvailable': (row['isAvailable'] as int) == 1,
    };

    return serializers.deserializeWith(
      FoodItem.serializer,
      normalizedRow,
    )!;
  }

  Map<String, dynamic> _cartItemToRow(CartItem item) {
    return serializers.serializeWith(
      CartItem.serializer,
      item,
    ) as Map<String, dynamic>;
  }

  CartItem _rowToCartItem(Map<String, dynamic> row) {
    return serializers.deserializeWith(
      CartItem.serializer,
      row,
    )!;
  }
}

