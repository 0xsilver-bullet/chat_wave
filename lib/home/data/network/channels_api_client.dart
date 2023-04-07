import 'package:chat_wave/core/data/network/api_error.dart';
import 'package:chat_wave/core/data/network/api_response.dart';
import 'package:chat_wave/core/data/network/b_wave_api.dart';
import 'package:chat_wave/core/data/network/dto/channel_dto.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:dio/dio.dart';

class ChannelsApiClient {
  final _dio = locator<Dio>();

  Future<ApiResponse<List<ChannelDto>>> fetchUserChannels() async {
    final response = await _dio.get('${BWaveApi.baseUrl}channels');
    if (response.statusCode == 200) {
      final data = (response.data['channels'] as List)
          .map((channelJson) => ChannelDto.fromJson(channelJson))
          .toList();
      return ApiResponse(isSuccessful: true, data: data);
    } else {
      return ApiResponse(
        isSuccessful: false,
        error: ApiError.fromJson(response.data),
      );
    }
  }
}
