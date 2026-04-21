import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class AuthService implements AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String?> signUp(String email, String password, {String? name}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<Map<String, String>?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return {
        'id': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
      };
    }
    return null;
  }
}