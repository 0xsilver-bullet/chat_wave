import 'package:floor/floor.dart';

import '../entity/friend.dart';

@dao
abstract class FriendDao {
  @Query('SELECT * FROM Friend')
  Stream<List<Friend>> findAllFriends();

  @insert
  Future<void> insertFriend(Friend friend);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllFriends(List<Friend> friends);
}
