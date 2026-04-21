import 'dart:async';
import 'dart:convert';
import 'package:built_collection/built_collection.dart';
//this package appwrite.dart is connnects the flutter app to appwrite
//it allows user level optn like crud on data level
import 'package:appwrite/appwrite.dart';
//dart_appwrite is allows the code to act as a admin when tlk to appwrote
//bcZ  admin only strcutre the db and give permsn to the users
//give alce name  admin to acceess db ,coll bcz to differntiate from the abv package it also have db,collection
import 'package:dart_appwrite/dart_appwrite.dart' as admin;
import '../core/appwrite_config.dart';
import '../core/services/appwrite_service.dart';
import '../core/services/local_storage_service.dart';
import '../model/restaurant.dart';
import '../model/food_item.dart';
import '../model/cart_item.dart';
import '../model/order.dart';
import '../model/serializers.dart';


class AppwriteStorageServiceImpl implements StorageService {
  Account get appwrite_account => AppwriteService.account;
  Databases get appwrite_db => AppwriteService.databases;

  final String _databaseId = AppwriteConfig.databaseId;
  final String _usersCollectionId = 'users';
  final String _restaurantsCollectionId = 'restaurants';
  final String _foodItemsCollectionId = 'food_items';
  final String _cartCollectionId = 'cart';
  final String _ordersCollectionId = 'orders';

  @override
  Future<void> init() async {}

  Future<String> _getUid() async {
    try {
      final user = await appwrite_account.get();
      return user.$id;
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final docs = await appwrite_db.listDocuments(
        databaseId: _databaseId,
        collectionId: _restaurantsCollectionId,
      );
      return docs.documents.map((doc) => _docToRestaurant(doc.data)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<void> insertRestaurant(Restaurant restaurant) async {
    try {
      await appwrite_db.createDocument(
        databaseId: _databaseId,
        collectionId: _restaurantsCollectionId,
        documentId: ID.unique(),
        data: _restaurantToDoc(restaurant),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> insertAllRestaurants(List<Restaurant> restaurants) async {
    for (var r in restaurants) {
      await insertRestaurant(r);
    }
  }

  @override
  Future<List<FoodItem>> getFoodItems(int restaurantId) async {
    try {
      final docs = await appwrite_db.listDocuments(
        databaseId: _databaseId,
        collectionId: _foodItemsCollectionId,
        queries: [
          Query.equal('restaurantId', restaurantId),
        ],
      );
      return docs.documents.map((doc) => _docToFoodItem(doc.data)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<void> insertFoodItem(FoodItem item) async {
    try {
      await appwrite_db.createDocument(
        databaseId: _databaseId,
        collectionId: _foodItemsCollectionId,
        documentId: ID.unique(),
        data: _foodItemToDoc(item),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> insertAllFoodItems(List<FoodItem> items) async {
    for (var i in items) {
      await insertFoodItem(i);
    }
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return [];

      final docs = await appwrite_db.listDocuments(
        databaseId: _databaseId,
        collectionId: _cartCollectionId,
        queries: [
          Query.equal('userId', uid),
        ],
      );
      return docs.documents.map((doc) => _docToCartItem(doc.data)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<void> addCartItem(CartItem item) async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return;

      final existing = await appwrite_db.listDocuments(
        databaseId: _databaseId,
        collectionId: _cartCollectionId,
        queries: [
          Query.equal('userId', uid),
          Query.equal('foodItemId', item.foodItemId),
        ],
      );

      if (existing.documents.isNotEmpty) {
        final docId = existing.documents.first.$id;
        final currentQty = existing.documents.first.data['quantity'] as int;
        await appwrite_db.updateDocument(
          databaseId: _databaseId,
          collectionId: _cartCollectionId,
          documentId: docId,
          data: {'quantity': currentQty + 1},
        );
      } else {
        final data = _cartItemToDoc(item);
        data['userId'] = uid;
        await appwrite_db.createDocument(
          databaseId: _databaseId,
          collectionId: _cartCollectionId,
          documentId: ID.unique(),
          data: data,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> updateCartItemQuantity(int cartItemId, int quantity) async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return;

      final docs = await appwrite_db.listDocuments(
        databaseId: _databaseId,
        collectionId: _cartCollectionId,
        queries: [
          Query.equal('userId', uid),
          Query.equal('id', cartItemId),
        ],
      );

      if (docs.documents.isNotEmpty) {
        await appwrite_db.updateDocument(
          databaseId: _databaseId,
          collectionId: _cartCollectionId,
          documentId: docs.documents.first.$id,
          data: {'quantity': quantity},
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return;

      final docs = await appwrite_db.listDocuments(
        databaseId: _databaseId,
        collectionId: _cartCollectionId,
        queries: [
          Query.equal('userId', uid),
          Query.equal('id', cartItemId),
        ],
      );

      if (docs.documents.isNotEmpty) {
        await appwrite_db.deleteDocument(
          databaseId: _databaseId,
          collectionId: _cartCollectionId,
          documentId: docs.documents.first.$id,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return;

      final docs = await appwrite_db.listDocuments(
        databaseId: _databaseId,
        collectionId: _cartCollectionId,
        queries: [
          Query.equal('userId', uid),
        ],
      );

      for (var doc in docs.documents) {
        await appwrite_db.deleteDocument(
          databaseId: _databaseId,
          collectionId: _cartCollectionId,
          documentId: doc.$id,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> placeOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
  }) async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return;

      final restaurantName = items.isNotEmpty ? items.first['restaurantName'] ?? '' : '';

      await appwrite_db.createDocument(
        databaseId: _databaseId,
        collectionId: _ordersCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': uid,
          'restaurantName': restaurantName,
          'items': jsonEncode(items),
          'totalAmount': totalAmount,
          'deliveryAddress': deliveryAddress,
          'status': 'pending',
          'orderDate': DateTime.now().toIso8601String(),
        },
      );
      await clearCart();
    } catch (e) {
      print(e);
    }
  }

  @override
  Stream<List<Order>> getOrders() {
    final controller = StreamController<List<Order>>();

    _getUid().then((uid) async {
      try {
        if (uid.isEmpty) {
          controller.add([]);
          return;
        }
        final docs = await appwrite_db.listDocuments(
          databaseId: _databaseId,
          collectionId: _ordersCollectionId,
          queries: [
            Query.equal('userId', uid),
            Query.orderDesc('orderDate'),
          ],
        );
        controller.add(docs.documents.map((doc) => _docToOrder(doc.data, doc.$id)).toList());
      } catch (e) {
        print(e);
        controller.add([]);
      }
    }).catchError((e) {
      print(e);
      controller.add([]);
    });

    return controller.stream;
  }

  @override
  Future<void> saveOrder(Order order) async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return;

      await appwrite_db.createDocument(
        databaseId: _databaseId,
        collectionId: _ordersCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': uid,
          ..._orderToDoc(order),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> addUser({required String name, required String email}) async {
    try {
      final uid = await _getUid();
      if (uid.isEmpty) return;

      await appwrite_db.createDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: uid,
        data: {
          'name': name,
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> _restaurantToDoc(Restaurant r) {
    var map = serializers.serializeWith(Restaurant.serializer, r) as Map<String, dynamic>;
    return map;
  }

  Restaurant _docToRestaurant(Map<String, dynamic> data) {
    return serializers.deserializeWith(Restaurant.serializer, data)!;
  }

  Map<String, dynamic> _foodItemToDoc(FoodItem i) {
    return serializers.serializeWith(FoodItem.serializer, i) as Map<String, dynamic>;
  }

  FoodItem _docToFoodItem(Map<String, dynamic> data) {
    return serializers.deserializeWith(FoodItem.serializer, data)!;
  }

  Map<String, dynamic> _cartItemToDoc(CartItem i) {
    return serializers.serializeWith(CartItem.serializer, i) as Map<String, dynamic>;
  }

  CartItem _docToCartItem(Map<String, dynamic> data) {
    return serializers.deserializeWith(CartItem.serializer, data)!;
  }

  Map<String, dynamic> _orderToDoc(Order o) {
    var map = serializers.serializeWith(Order.serializer, o) as Map<String, dynamic>;
    map['items'] = jsonEncode(o.items.map((e) => serializers.serializeWith(CartItem.serializer, e)).toList());
    map['orderDate'] = o.placedAt.toIso8601String();
    return map;
  }

  Order _docToOrder(Map<String, dynamic> data, String docId) {
    final itemsRaw = jsonDecode(data['items'] as String) as List;
    final items = itemsRaw.map((e) => serializers.deserializeWith(CartItem.serializer, e)!).toList();

    return Order((b) => b
      ..id = int.tryParse(docId) ?? 0
      ..userId = data['userId'] as String // Added missing userId
      ..restaurantName = data['restaurantName'] as String
      ..items.replace(items)
      ..totalAmount = (data['totalAmount'] as num).toDouble()
      ..status = data['status'] as String
      ..placedAt = DateTime.parse(data['orderDate'] as String)
      ..deliveryAddress = data['deliveryAddress'] as String);
  }

  @override
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final doc = await appwrite_db.getDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
      );
      return doc.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await appwrite_db.updateDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
        data: data,
      );
    } catch (e) {
      print(e);
    }
  }
}


class AppwriteAdminSetup {
  static Future<void> setup() async {
    final client = admin.Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId)
        .setKey(AppwriteConfig.apiKey);

    final db = admin.Databases(client);
    final dId = AppwriteConfig.databaseId;

    try {
      await db.create(databaseId: dId, name: 'Food Delivery');
    } catch (e) {
      print(e);
    }

    final storage = admin.Storage(client);
    try {
      await storage.createBucket(
        bucketId: AppwriteConfig.bucketId,
        name: 'Food Delivery Bucket',
        permissions: [
          admin.Permission.read(admin.Role.any()),
          admin.Permission.write(admin.Role.users()),
        ],
        fileSecurity: false,
      );
    } catch (e) {
      print(e);
    }

    await _setupCollection(db, dId, 'users', 'Users', [
      _Attr('name', 'string', size: 255),
      _Attr('email', 'string', size: 255),
      _Attr('profilePictureId', 'string', size: 255, required: false),
      _Attr('createdAt', 'string', size: 255, required: false),
    ]);

    await _setupCollection(db, dId, 'restaurants', 'Restaurants', [
      _Attr('id', 'integer'),
      _Attr('name', 'string', size: 255),
      _Attr('cuisine', 'string', size: 255),
      _Attr('imageUrl', 'string', size: 500),
      _Attr('rating', 'float'),
      _Attr('deliveryTime', 'string', size: 100),
      _Attr('deliveryFee', 'float'),
      _Attr('isOpen', 'boolean'),
    ]);
    await _setupCollection(db, dId, 'food_items', 'Food Items', [
      _Attr('id', 'integer'),
      _Attr('restaurantId', 'integer'),
      _Attr('name', 'string', size: 255),
      _Attr('description', 'string', size: 1000),
      _Attr('price', 'float'),
      _Attr('imageUrl', 'string', size: 500),
      _Attr('category', 'string', size: 100),
      _Attr('isAvailable', 'boolean'),
    ]);

    await _setupCollection(db, dId, 'cart', 'Cart', [
      _Attr('id', 'integer'),
      _Attr('foodItemId', 'integer'),
      _Attr('foodItemName', 'string', size: 255),
      _Attr('price', 'float'),
      _Attr('imageUrl', 'string', size: 500),
      _Attr('quantity', 'integer'),
      _Attr('restaurantId', 'integer'),
      _Attr('restaurantName', 'string', size: 255),
      _Attr('userId', 'string', size: 255),
    ]);

    await _setupCollection(db, dId, 'orders', 'Orders', [
      _Attr('userId', 'string', size: 255),
      _Attr('restaurantName', 'string', size: 255),
      _Attr('items', 'string', size: 5000),
      _Attr('totalAmount', 'float'),
      _Attr('deliveryAddress', 'string', size: 1000),
      _Attr('status', 'string', size: 100),
      _Attr('orderDate', 'string', size: 100),
    ]);
  }

  static Future<void> _setupCollection(admin.Databases db, String dbId, String colId, String name, List<_Attr> attrs) async {
    try {
      await db.createCollection(databaseId: dbId, collectionId: colId, name: name);
    } catch (e) {
      print(e);
    }

    for (var attr in attrs) {
      try {
        switch (attr.type) {
          case 'string':
            await db.createStringAttribute(databaseId: dbId, collectionId: colId, key: attr.key, size: attr.size ?? 255, xrequired: attr.required);
            break;
          case 'integer':
            await db.createIntegerAttribute(databaseId: dbId, collectionId: colId, key: attr.key, xrequired: attr.required);
            break;
          case 'float':
            await db.createFloatAttribute(databaseId: dbId, collectionId: colId, key: attr.key, xrequired: attr.required);
            break;
          case 'boolean':
            await db.createBooleanAttribute(databaseId: dbId, collectionId: colId, key: attr.key, xrequired: attr.required);
            break;
        }
      } catch (e) {
        print(e);
      }
    }
  }
}

class _Attr {
  //name of the attribute
  final String key;
  //typ of attr
  final String type;
  final int? size;
  //it tell if it is mandory or not
  final bool required;
  _Attr(this.key, this.type, {this.size, this.required = true});
}

