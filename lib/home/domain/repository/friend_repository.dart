import 'package:chat_wave/core/data/db/entity/friend.dart';

abstract class FriendRepository {
  Stream<List<FriendEntity>> watchUserFriends();

  Future<void> addFriend(String username);
}
