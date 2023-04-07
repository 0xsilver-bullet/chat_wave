import 'package:chat_wave/core/data/network/dto/user_info_dto.dart';

class ChannelDto {
  ChannelDto({
    required this.id,
    required this.name,
    required this.type,
    required this.users,
  });

  ChannelDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        users = (json['users'] as List)
            .map((userInfoJson) => UserInfoDto.fromJson(userInfoJson))
            .toList();

  final int id;
  final String? name;
  final int type;
  final List<UserInfoDto> users;
}
