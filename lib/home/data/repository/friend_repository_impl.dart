import 'package:chat_wave/core/data/db/chat_wave_db.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/home/data/mapper/friend_mapper.dart';
import 'package:chat_wave/home/data/network/friends_api_client.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl(ChatWaveDb db) : friendDao = db.friendDao {
    _init();
  }

  final api = FriendsApiClient();
  final FriendDao friendDao;

  @override
  Stream<List<Friend>> watchUserFriends() {
    return friendDao.findAllFriends();
  }

  Future<void> _init() async {
    final apiResponse = await api.getUserFriends();
    if (apiResponse.isSuccessful && apiResponse.data != null) {
      print('inserting frinds into dao...');
      final friends = apiResponse.data!
          .map(
            (networkFriend) => networkFriend.toFriend(),
          )
          .toList();
      friendDao.insertAllFriends(friends);
    }
  }
}
