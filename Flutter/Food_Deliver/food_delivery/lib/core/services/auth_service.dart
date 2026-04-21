
abstract class AuthenticationService {
  Future<void> signUp(String email, String password, {String? name});
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<Map<String, String>?> getCurrentUser();
}
