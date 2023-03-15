abstract class TokenManager {
  String? get accessToken;
  String? get refreshToken;

  Future<void> init();

  // indicate if refresh successfully or not
  Future<bool> refresh();
}
