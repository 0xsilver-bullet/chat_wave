import 'dart:convert';

import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:dio/dio.dart';

import 'package:chat_wave/core/data/network/dto/user_info_dto.dart';
import 'package:chat_wave/utils/locator.dart';

class ProfileApi {
  final _dio = locator<Dio>();

  Future<UserInfoDto?> updateUserProfile(
    String? name,
    String? profilePicPath,
  ) async {
    final formData = FormData();

    final changes = jsonEncode({
      'name': name,
    });
    formData.fields.add(MapEntry('form', changes));

    if (profilePicPath != null) {
      String fileName = profilePicPath.split('/').last;
      final imageFile = await MultipartFile.fromFile(
        profilePicPath,
        filename: fileName,
      );
      formData.files.add(MapEntry('', imageFile));
    }

    final response = await _dio.post(
      '${BWaveApi.baseUrl}profile/edit',
      data: formData,
    );
    if (response.statusCode == 200) {
      return UserInfoDto.fromJson(response.data['userInfo']);
    }
    return null;
  }
}
