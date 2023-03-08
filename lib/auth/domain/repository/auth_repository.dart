abstract class AuthRepository {
  Future<bool> login(String username, String password);
  Future<bool> signup(String name, String username, String password);
}
