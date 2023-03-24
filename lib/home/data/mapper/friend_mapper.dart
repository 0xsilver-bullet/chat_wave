import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/home/data/network/dto/friend_dto.dart';

extension Mapping on FriendDto {
  Friend toFriend() {
    return Friend(
      name: this.name,
      username: this.username,
      id: this.id,
      profilePicUrl: this.profilePicUrl,
    );
  }
}
