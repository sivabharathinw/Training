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
      'items': items, // already correct key-value maps from view_model
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      // Store as ISO8601 String — built_value serializer can read this back
      'placedAt': DateTime.now().toIso8601String(),
      // Also store as Timestamp for Firestore console visibility
      'orderDate': FieldValue.serverTimestamp(),
      'status': 'pending',
    };

    return _firestore.collection('orders').add(orderData);
  }

  @override
  Future<List<Order>> getOrders() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // No .orderBy() — avoids needing a Firestore composite index.
    // Sorting is done locally below.
    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .get();

    final orders = snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());

      // Add int id from document id
      data['id'] = doc.id.hashCode;

      // Remove Firestore Timestamp — built_value serializer cannot handle it.
      // We rely on the ISO8601 String 'placedAt' field instead.
      data.remove('orderDate');

      // Fallback if placedAt is missing
      data['placedAt'] ??= DateTime.now().toIso8601String();

      // Deserialize each item map into a CartItem using built_value serializer.
      // Keys must exactly match CartItem fields:
      // id, foodItemId, foodItemName, price, imageUrl, quantity,
      // restaurantId, restaurantName
      final rawItems = (data['items'] as List<dynamic>?) ?? [];
      final cartItems = rawItems.asMap().entries.map((entry) {
        final itemMap = Map<String, dynamic>.from(
            entry.value as Map<dynamic, dynamic>);
        // CartItem.id is required but not stored in Firestore — use list index
        itemMap['id'] = entry.key;
        return serializers.deserializeWith(CartItem.serializer, itemMap)!;
      }).toList();

      // Build Order using deserialized CartItems
      return Order((b) => b
        ..id = data['id'] as int
        ..userId = uid
        ..restaurantName = data['restaurantName']?.toString() ?? ''
        ..items = ListBuilder<CartItem>(cartItems)
        ..totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0
        ..status = data['status']?.toString() ?? 'pending'
        ..placedAt = data['placedAt'].toString()
        ..deliveryAddress = data['deliveryAddress']?.toString() ?? '');
    }).toList();

    // Sort newest first
    orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));

    return orders;
  }
}