import 'package:built_collection/built_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/firestore_service.dart';
import 'package:food_delivery/model/order.dart';
import '../model/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

class FirestoreServiceImpl implements FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('User');

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
  Future<void> placeOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final orderData = {
      'userId': uid,
      'restaurantName': items.isNotEmpty ? items.first['restaurantName'] : '',
      'items': items,
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'orderDate': FieldValue.serverTimestamp(),
      'status': 'pending',
    };

    return _firestore.collection('orders').add(orderData);
  }

  @override
  Future<List<Order>> getOrders() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('orderDate', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final rawItems = (data['items'] as List<dynamic>? ?? []);
      final cartItems = rawItems.asMap().entries.map((entry) {
        final item = entry.value as Map<String, dynamic>;
        return CartItem((b) => b
          ..id = entry.key
          ..foodItemId = 0
          ..foodItemName = item['name'] as String
          ..price = (item['price'] as num).toDouble()
          ..quantity = (item['quantity'] as num).toInt()
          ..imageUrl = ''
          ..restaurantId = 0
          ..restaurantName = item['restaurantName'] as String);
      }).toList();

      final timestamp = data['orderDate'] as Timestamp?;
      final placedAt = timestamp?.toDate() ?? DateTime.now();

      return Order((b) => b
        ..id = doc.id.hashCode
        ..restaurantName = data['restaurantName'] as String? ??
            (cartItems.isNotEmpty ? cartItems.first.restaurantName : '')
        ..items = ListBuilder(cartItems)
        ..totalAmount = (data['totalAmount'] as num).toDouble()
        ..status = data['status'] as String? ?? 'pending'
        ..placedAt = placedAt
        ..deliveryAddress = data['deliveryAddress'] as String? ?? '');
    }).toList();
  }
}