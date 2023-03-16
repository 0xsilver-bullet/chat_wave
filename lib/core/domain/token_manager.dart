abstract class TokenManager {
  String? get accessToken;
  String? get refreshToken;

  Future<void> init();

  // indicate if refresh successfully or not
  Future<bool> refresh();

  // updates the tokens in the token manager.
  // also it saves the new tokens into the secure local storage
  Future<void> saveTokens(String accessToken, String refreshToken);

  // sets the token to null in the token manager
  // also it deletes the tokens from the local storages.
  Future<void> deleteTokens();
}
