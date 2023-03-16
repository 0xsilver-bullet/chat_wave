import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:chat_wave/core/domain/secure_local_storage.dart';
import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/utils/locator.dart';
import 'network/b_wave_api.dart';

class TokenManagerImpl extends TokenManager {
  final storage = locator<SecureStorage>();
  final client = Dio();

  bool _isRefreshing = false;
  Completer<bool>? _completer;

  TokenManagerImpl() {
    client.options.validateStatus =
        (status) => true; // don't throw exceptions on failures
    client.options.responseType = ResponseType.json;
  }

  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> init() async {
    // initialize the values from the local storage.
    _accessToken = await storage.getAccessToken();
    _refreshToken = await storage.getRefreshToken();
  }

  @override
  Future<bool> refresh() async {
    if (!_isRefreshing && _refreshToken != null) {
      _isRefreshing = true;
      _completer = Completer();
      final refreshTokenRequest = jsonEncode(
        {
          'token': refreshToken,
        },
      );
      final response = await client.post(
        '${BWaveApi.baseUrl}auth/refresh',
        data: refreshTokenRequest,
      );
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final newAccessToken = jsonResponse['accessToken'];
        final newRefreshToken = jsonResponse['refreshToken'];
        // now save the new access and refresh tokens.
        _accessToken = newAccessToken;
        _refreshToken = newRefreshToken;
        await storage.saveToken(newAccessToken);
        await storage.saveRefreshToken(newRefreshToken);
        _isRefreshing = false;
        _completer!.complete(true);
        _completer = null;
        return true;
      } else {
        _isRefreshing = false;
        _completer!.complete(false);
        _completer = null;
        return false;
      }
    } else {
      // then we are already refreshing
      final successful = await _completer!.future;
      return successful;
    }
  }

  // TODO: If we try to remove the tokens while we are actully refreshing the token, somehting might go wrong and you need to think about this.
  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await storage.saveToken(accessToken);
    return await storage.saveRefreshToken(refreshToken);
  }

  @override
  Future<void> deleteTokens() async {
    _accessToken = null;
    _refreshToken = null;
    return await storage.deleteTokens();
  }

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;
}
