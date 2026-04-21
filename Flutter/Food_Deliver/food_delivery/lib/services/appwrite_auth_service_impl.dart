import 'package:appwrite/appwrite.dart';
import '../core/services/auth_service.dart';
import '../core/services/appwrite_service.dart';

class AppwriteAuthServiceImpl implements AuthenticationService {
  Account get appwrite_account => AppwriteService.account;

  @override
  Future<void> signUp(String email, String password, {String? name}) async {
    try {
      await appwrite_account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await appwrite_account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await appwrite_account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await appwrite_account.deleteSession(sessionId: 'current');
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final user = await appwrite_account.get();
      return user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<Map<String, String>?> getCurrentUser() async {
    try {
      final user = await appwrite_account.get();
      return {
        'id': user.$id,
        'name': user.name,
        'email': user.email,
      };
    } catch (e) {
      print(e);
      return null;
    }
  }
}