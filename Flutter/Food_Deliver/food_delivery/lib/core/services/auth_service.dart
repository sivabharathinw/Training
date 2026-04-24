
abstract class AuthenticationService {
  Future<bool> signUp(String email, String password, {String? name});
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<Map<String, String>?> getCurrentUser();
}
