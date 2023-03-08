import 'dart:convert';
import 'package:chat_wave/data/network/tokens_dto.dart';
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
}
