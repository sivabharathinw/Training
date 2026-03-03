
abstract class AuthenticationService {
  Future<String?> signUp(String email, String password);
  Future<String?> login(String email, String password);
  Future<void> logout();
}