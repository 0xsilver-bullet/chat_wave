import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_wave/auth/data/network/response/login_response.dart';
import 'package:chat_wave/auth/domain/errors/login_failure.dart';
import 'package:chat_wave/auth/domain/errors/signup_failure.dart';
import 'package:chat_wave/auth/domain/repository/auth_repository.dart';
import 'package:chat_wave/core/data/secure_local_storage_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _storage = SecureStorageImpl();

  @override
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('http://192.168.1.4:8080/auth/login');
    final body = jsonEncode(
      {
        'username': username,
        'password': password,
      },
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    final json = jsonDecode(response.body);

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
    await _storage.saveToken(tokens.accessToken);
    await _storage.saveRefreshToken(tokens.refreshToken);
    return true;
  }

  @override
  Future<bool> signup(String name, String username, String password) async {
    final url = Uri.parse('http://192.168.1.4:8080/auth/signup');
    final body = jsonEncode(
      {
        'name': name,
        'username': username,
        'password': password,
      },
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) return true;
    // Then request has failed
    // extract error code and throw a SignupFailure exception
    final jsonResponse = jsonDecode(response.body);
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
}
