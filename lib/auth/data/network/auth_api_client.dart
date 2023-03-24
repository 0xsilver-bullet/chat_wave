import 'dart:convert';

import 'package:chat_wave/auth/data/network/response/signup_response.dart';
import 'package:dio/dio.dart';

import 'package:chat_wave/auth/data/network/response/login_response.dart';
import 'package:chat_wave/core/data/network/api_error.dart';
import 'package:chat_wave/core/data/network/api_response.dart';
import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:chat_wave/utils/locator.dart';

class AuthApiClient {
  final _dio = locator<Dio>();

  Future<ApiResponse<LoginResponse>> login(
    String username,
    String password,
  ) async {
    final body = jsonEncode(
      {
        'username': username,
        'password': password,
      },
    );
    final response = await _dio.post(
      '${BWaveApi.baseUrl}auth/login',
      data: body,
    );
    if (response.statusCode == 200) {
      return ApiResponse(
        isSuccessful: true,
        data: LoginResponse.fromJson(response.data),
      );
    } else {
      return ApiResponse(
        isSuccessful: false,
        error: ApiError.fromJson(response.data),
      );
    }
  }

  Future<ApiResponse<SignupResponse>> signup(
    String name,
    String username,
    String password,
  ) async {
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
    );
    if (response.statusCode == 200) {
      return ApiResponse(
        isSuccessful: true,
        data: SignupResponse.fromJson(response.data),
      );
    } else {
      return ApiResponse(
        isSuccessful: false,
        error: ApiError.fromJson(response.data),
      );
    }
  }

  Future<ApiResponse<void>> logout() async {
    final response = await _dio.post('${BWaveApi.baseUrl}auth/logout');
    if (response.statusCode == 200) {
      return ApiResponse(isSuccessful: true);
    } else {
      return ApiResponse(isSuccessful: false);
    }
  }
}
