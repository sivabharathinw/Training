import 'package:built_collection/built_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/firestore_service.dart';
import 'package:food_delivery/model/order.dart';
import '../model/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:food_delivery/model/serializers.dart';

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
    //snapShots returns a stream of a firestore data
        .snapshots()
    //it takes each doc in snapshot and trosnfors to dart obj
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
}