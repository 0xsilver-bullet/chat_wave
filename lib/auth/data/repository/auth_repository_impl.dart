import 'package:chat_wave/auth/data/network/auth_api_client.dart';
import 'package:chat_wave/core/data/mapper/user_info_mapper.dart';
import 'package:chat_wave/core/domain/app_preferences.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:chat_wave/auth/domain/errors/login_failure.dart';
import 'package:chat_wave/auth/domain/errors/signup_failure.dart';
import 'package:chat_wave/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _tokenManager = locator<TokenManager>();
  final api = AuthApiClient();
  final _prefs = locator<AppPreferences>();

  @override
  Future<bool> login(String username, String password) async {
    final apiResonse = await api.login(username, password);
    if (!apiResonse.isSuccessful) {
      // request has failed, error must be initialized
      switch (apiResonse.error?.errorCode ?? 0) {
        case LoginFailure.userNotFound:
          throw UserNotFound();
        case LoginFailure.invalidCredentials:
          throw InvalidCredentials();
        default:
          throw UnknownLoginError();
      }
    }
    if (apiResonse.data == null) {
      throw UnknownLoginError();
    }
    final tokens = apiResonse.data!.tokens;
    await _tokenManager.saveTokens(tokens.accessToken, tokens.refreshToken);
    final userInfoDto = apiResonse.data!.userInfo;
    final userInfo = userInfoDto.toUserInfo();
    await _prefs.saveUserInfo(userInfo);
    return true;
  }

  @override
  Future<bool> signup(String name, String username, String password) async {
    final apiResponse = await api.signup(name, username, password);

    if (apiResponse.isSuccessful) return true;
    // Then request has failed
    final error = apiResponse.error;
    if (error == null) {
      throw UnknownSignupError();
    }
    switch (error.errorCode) {
      case SignupFailure.usernameAlreadyExistsCode:
        throw UsernameAlreadyExists();
      default:
        throw UnknownSignupError();
    }
  }

  @override
  Future<bool> logout() async {
    final apiResponse = await api.logout();
    if (apiResponse.isSuccessful) {
      await _tokenManager.deleteTokens();
      return true;
    }
    // then logout has failed
    return false;
  }
}
