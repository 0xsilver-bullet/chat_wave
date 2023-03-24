import 'package:dio/dio.dart';

import 'package:chat_wave/core/data/network/api_error.dart';
import 'package:chat_wave/core/data/network/api_response.dart';
import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:chat_wave/home/data/network/dto/friend_dto.dart';
import 'package:chat_wave/utils/locator.dart';

class FriendsApiClient {
  final _dio = locator<Dio>();

  Future<ApiResponse<List<FriendDto>>> getUserFriends() async {
    final response = await _dio.get('${BWaveApi.baseUrl}connection');
    if (response.statusCode == 200) {
      final List<FriendDto> friends = (response.data as List<dynamic>)
          .map((friendJson) => FriendDto.fromJson(friendJson))
          .toList();
      return ApiResponse(
        isSuccessful: true,
        data: friends,
      );
    } else {
      return ApiResponse(
        isSuccessful: false,
        error: ApiError.fromJson(response.data),
      );
    }
  }
}
