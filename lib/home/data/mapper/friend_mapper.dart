import 'package:chat_wave/core/data/db/entity/dm_channel.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/home/data/network/dto/friend_dto.dart';

extension Mapping on FriendDto {
  FriendEntity toFriend() {
    return FriendEntity(
      name: name,
      username: username,
      id: id,
      profilePicUrl: profilePicUrl,
    );
  }

  DmChannelEntity toChannel() {
    return DmChannelEntity(
      id: id,
      name: name,
      username: username,
      profilePicUrl: profilePicUrl,
      lastMessage: null,
    );
  }
}
