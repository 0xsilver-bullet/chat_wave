import 'package:chat_wave/core/data/db/entity/channel_full.dart';
import 'package:chat_wave/core/data/mapper/channel_mapper.dart';
import 'package:chat_wave/core/data/mapper/user_info_mapper.dart';
import 'package:chat_wave/core/data/network/dto/channel_dto.dart';

extension Mapper on ChannelDto {
  ChannelFullEntity toFullChannelEntity() {
    final channel = toChannelEntity();
    final channelUsers =
        users.map((userInfoDto) => userInfoDto.toFriendEntity()).toList();

    return ChannelFullEntity(
      channel: channel,
      channelUsers: channelUsers,
      lastMessage: null,
    );
  }
}
