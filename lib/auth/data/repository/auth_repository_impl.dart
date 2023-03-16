import 'dart:convert';
import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:dio/dio.dart';
import 'package:chat_wave/auth/data/network/response/login_response.dart';
import 'package:chat_wave/auth/domain/errors/login_failure.dart';
import 'package:chat_wave/auth/domain/errors/signup_failure.dart';
import 'package:chat_wave/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _tokenManager = locator<TokenManager>();
  final _dio = locator<Dio>();

  @override
  Future<bool> login(String username, String password) async {
    final body = jsonEncode(
      {
        'username': username,
        'password': password,
      },
    );
    final response = await _dio.post(
      '${BWaveApi.baseUrl}auth/login',
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final json = response.data;

    if (response.statusCode != 200) {
      final errorCode = json['errorCode'] as int?;
      if (errorCode == null) {
        throw UnknownLoginError();
      }
      switch (errorCode) {
        case LoginFailure.userNotFound:
          throw UserNotFound();
        case LoginFailure.invalidCredentials:
          throw InvalidCredentials();
        default:
          throw UnknownLoginError();
      }
    }

    final loginResponse = LoginResponse.fromJson(json);

    final tokens = loginResponse.tokens;
    await _tokenManager.saveTokens(tokens.accessToken, tokens.refreshToken);
    return true;
  }

  @override
  Future<bool> signup(String name, String username, String password) async {
    final body = jsonEncode(
      {
        'name': name,
        'username': username,
        'password': password,
      },
    );
    final response = await _dio.post(
      '${BWaveApi.baseUrl}auth/signup',
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) return true;
    // Then request has failed
    // extract error code and throw a SignupFailure exception
    final jsonResponse = response.data;
    final errorCode = jsonResponse['errorCode'] as int?;
    if (errorCode == null) {
      throw UnknownSignupError();
    }
    switch (errorCode) {
      case SignupFailure.usernameAlreadyExistsCode:
        throw UsernameAlreadyExists();
      default:
        throw UnknownSignupError();
    }
  }

  @override
  Future<bool> logout() async {
    final response = await _dio.post('${BWaveApi.baseUrl}auth/logout');
    if (response.statusCode == 200) {
      await _tokenManager.deleteTokens();
      return true;
    }
    // then logout has failed
    return false;
  }
}
