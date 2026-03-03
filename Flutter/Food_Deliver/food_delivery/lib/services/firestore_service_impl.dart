import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/firestore_service.dart';

class FirestoreServiceImpl implements FirestoreService {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('user');

  @override
  Future<void> addUser({required String name, required String email}) async {
    await usersCollection.add({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

}