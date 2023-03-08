import 'dart:convert';
import 'package:chat_wave/data/network/dto/tokens_dto.dart';
import 'package:chat_wave/data/network/errors/signup_failure.dart';
import 'package:chat_wave/data/secure_local_storage_impl.dart';
import 'package:chat_wave/domain/repository/auth_repository.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  final _storage = SecureStorageImpl();

  @override
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('http://192.168.1.2:8080/auth/login');
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
    if (response.statusCode != 200) return false;
    final json = jsonDecode(response.body);
    final tokens = TokensDto.fromJson(json);
    await _storage.saveToken(tokens.accessToken);
    await _storage.saveRefreshToken(tokens.refreshToken);
    return true;
  }

  @override
  Future<bool> signup(String name, String username, String password) async {
    final url = Uri.parse('http://192.168.1.2:8080/auth/signup');
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
