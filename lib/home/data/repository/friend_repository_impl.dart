import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/home/data/mapper/friend_mapper.dart';
import 'package:chat_wave/home/data/network/friends_api_client.dart';
import 'package:chat_wave/home/domain/error/add_friend_error.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl(FriendDao friendDao) : _friendDao = friendDao {
    _init();
  }

  final api = FriendsApiClient();
  final FriendDao _friendDao;

  @override
  Stream<List<FriendEntity>> watchUserFriends() {
    return _friendDao.watchFriends;
  }

  @override
  Future<void> addFriend(String username) async {
    final apiResponse = await api.addUserAsFriend(username);
    if (apiResponse.isSuccessful) {
      final friend = apiResponse.data!.toFriend();
      await _friendDao.insertFriend(friend);
    } else {
      final error = apiResponse.error!;
      switch (error.errorCode) {
        case AddFriendError.alreadyFriendsCode:
          throw AlreadyFriends();
        case AddFriendError.userNotFound:
          throw UserNotFound();
        default:
          throw Exception();
      }
    }
  }

  Future<void> _init() async {
    final apiResponse = await api.getUserFriends();
    if (apiResponse.isSuccessful && apiResponse.data != null) {
      final friends = apiResponse.data!
          .map(
            (networkFriend) => networkFriend.toFriend(),
          )
          .toList();
      _friendDao.insertAllFriends(friends);
    }
  }
}
