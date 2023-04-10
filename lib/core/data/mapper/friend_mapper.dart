import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/core/domain/model/user_info.dart';

extension Mapper on FriendEntity {
  UserInfo toUserInfo() {
    return UserInfo(
      name: name,
      username: username,
      profilePicUrl: profilePicUrl,
      id: id,
    );
  }
}
