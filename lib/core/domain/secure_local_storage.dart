abstract class SecureStorage {
  static const tokenKey = "access_token";
  static const refreshTokenKey = "refresh_token_key";

  Future<bool> hasToken();

  Future<bool> hasRefreshToken();

  Future<void> saveToken(String accessToken);

  Future<void> saveRefreshToken(String refreshToken);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> deleteTokens();
}
