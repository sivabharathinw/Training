import 'package:built_collection/built_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/local_storage_service.dart';
import 'package:food_delivery/model/order.dart';
import '../model/cart_item.dart';
import '../model/restaurant.dart';
import '../model/food_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:food_delivery/model/serializers.dart';



class FirestoreServiceImpl implements StorageService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('User');
@override
Future<void> init() async {

}
  @override
  Future<void> addUser({
    required String name,
    required String email,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return usersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await usersCollection.doc(userId).get();
    return doc.data() as Map<String, dynamic>?;
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> data) {
    return usersCollection.doc(userId).update(data);
  }

  @override
  Future<void> placeOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final orderData = {
      'userId': uid,
      'restaurantName': items.isNotEmpty ? items.first['restaurantName'] ?? '' : '',
      'items': items,
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,

      'orderDate': FieldValue.serverTimestamp(),
      'status': 'pending',
    };

    return _firestore.collection('orders').add(orderData);
  }

  @override
  Stream<List<Order>> getOrders() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
    //snapshots returns a stream of a firestore data
        .snapshots()
    //it takes each doc in snapshot and transforms to dart obj
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());

        data['id'] = doc.id.hashCode;

        final placedAt = (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now();

        final rawItems = (data['items'] as List<dynamic>?) ?? [];
        final cartItems = rawItems.asMap().entries.map((entry) {
          final itemMap = Map<String, dynamic>.from(
              entry.value as Map<dynamic, dynamic>);
          itemMap['id'] = entry.key;
          return serializers.deserializeWith(CartItem.serializer, itemMap)!;
        }).toList();

        return Order((b) => b
          ..id = data['id'] as int
          ..userId = uid
          ..restaurantName = data['restaurantName']?.toString() ?? ''
          ..items = ListBuilder<CartItem>(cartItems)
          ..totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0
          ..status = data['status']?.toString() ?? 'pending'
          ..placedAt = placedAt
          ..deliveryAddress = data['deliveryAddress']?.toString() ?? '');
      }).toList();

      orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
      return orders;
    });
  }


@override
//get restaurants and food items from firestore
Future<List<Restaurant>> getRestaurants() async {
  final snapshot = await _firestore.collection('restaurants').get();
  return snapshot.docs.map((doc) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = int.tryParse(doc.id) ?? doc.id.hashCode;
    return serializers.deserializeWith(Restaurant.serializer, data)!;
  }).toList();
}

@override
//insert restaurants and food items to firestore
Future<void> insertRestaurant(Restaurant restaurant) async {
  final data = serializers.serializeWith(Restaurant.serializer, restaurant)
  as Map<String, dynamic>;
  await _firestore.collection('restaurants').doc(restaurant.id.toString()).set(data);
}

@override
//insert multiple restaurants and food items to firestore
Future<void> insertAllRestaurants(List<Restaurant> restaurants) async {
  final batch = _firestore.batch();
  for (final r in restaurants) {
    final data = serializers.serializeWith(Restaurant.serializer, r)
    as Map<String, dynamic>;
    final ref = _firestore.collection('restaurants').doc(r.id.toString());
    batch.set(ref, data);
  }
  await batch.commit();
}

@override
//get food items for a specific restaurant from firestore
Future<List<FoodItem>> getFoodItems(int restaurantId) async {
  final snapshot = await _firestore
      .collection('restaurants')
      .doc(restaurantId.toString())
      .collection('foodItems')
      .get();
  return snapshot.docs.map((doc) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = int.tryParse(doc.id) ?? doc.id.hashCode;
    return serializers.deserializeWith(FoodItem.serializer, data)!;
  }).toList();
}

@override
//insert a food item for a specific restaurant to firestore
Future<void> insertFoodItem(FoodItem item) async {
  final data = serializers.serializeWith(FoodItem.serializer, item)
  as Map<String, dynamic>;
  await _firestore
      .collection('restaurants')
      .doc(item.restaurantId.toString())
      .collection('foodItems')
      .doc(item.id.toString())
      .set(data);
}

@override
//insert multiple food items for a specific restaurant to firestore
Future<void> insertAllFoodItems(List<FoodItem> items) async {
  final batch = _firestore.batch();
  for (final item in items) {
    final data = serializers.serializeWith(FoodItem.serializer, item)
    as Map<String, dynamic>;
    final ref = _firestore
        .collection('restaurants')
        .doc(item.restaurantId.toString())
        .collection('foodItems')
        .doc(item.id.toString());
    batch.set(ref, data);
  }
  await batch.commit();
}

@override
//get cart items for the current user from firestore
Future<List<CartItem>> getCartItems() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapshot = await usersCollection.doc(uid).collection('cart').get();
  return snapshot.docs.map((doc) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = int.tryParse(doc.id) ?? doc.id.hashCode;
    return serializers.deserializeWith(CartItem.serializer, data)!;
  }).toList();
}

@override
//add a cart item for the current user to firestore
Future<void> addCartItem(CartItem item) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final data = serializers.serializeWith(CartItem.serializer, item)
  as Map<String, dynamic>;
  await usersCollection.doc(uid).collection('cart').doc(item.id.toString()).set(data);
}

@override
//update the quantity of a cart item for the current user in firestore
Future<void> updateCartItemQuantity(int cartItemId, int quantity) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await usersCollection
      .doc(uid)
      .collection('cart')
      .doc(cartItemId.toString())
      .update({'quantity': quantity});
}

@override
//remove a cart item for the current user from firestore
Future<void> removeCartItem(int cartItemId) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await usersCollection
      .doc(uid)
      .collection('cart')
      .doc(cartItemId.toString())
      .delete();
}

@override
Future<void> clearCart() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapshot = await usersCollection.doc(uid).collection('cart').get();
  final batch = _firestore.batch();
  for (final doc in snapshot.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();
}

@override
Future<void> saveOrder(Order order) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final itemsList = order.items.map((item) {
    return serializers.serializeWith(CartItem.serializer, item)
    as Map<String, dynamic>;
  }).toList();

  await _firestore.collection('orders').add({
    'userId': uid,
    'restaurantName': order.restaurantName,
    'items': itemsList,
    'totalAmount': order.totalAmount,
    'deliveryAddress': order.deliveryAddress,
    'status': order.status,
    'orderDate': FieldValue.serverTimestamp(),
  });
}}