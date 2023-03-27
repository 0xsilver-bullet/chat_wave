abstract class SecureStorage {
  static const tokenKey = "access_token";
  static const refreshTokenKey = "refresh_token_key";
  static const userIdKey = "user_id_key";

  Future<bool> hasToken();

  Future<bool> hasRefreshToken();

  Future<void> saveToken(String accessToken);

  Future<void> saveRefreshToken(String refreshToken);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> deleteTokens();

  Future<void> saveUserId(int userId);

  Future<int?> getUserId();
}
