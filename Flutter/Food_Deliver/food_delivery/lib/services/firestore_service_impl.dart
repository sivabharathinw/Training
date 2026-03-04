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

    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('orderDate', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // convert firestore timestamp to dateTime
      data['placedAt'] = (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now();
      data['id'] = doc.id.hashCode; // add id to data for your model

      // deserialize into order object automatically
      final order = serializers.deserializeWith(Order.serializer, data);
      return order!;
    }).toList();
  }
}