import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/home/data/mapper/friend_mapper.dart';
import 'package:chat_wave/home/data/network/friends_api_client.dart';
import 'package:chat_wave/home/domain/error/add_friend_error.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl(
    FriendDao friendDao,
  ) : _friendDao = friendDao;

  final api = FriendsApiClient();
  final FriendDao _friendDao;

  @override
  Future<void> addFriend(String username) async {
    final apiResponse = await api.addUserAsFriend(username);
    if (apiResponse.isSuccessful) {
      final friend = apiResponse.data!.toFriend();
      await _friendDao.insert(friend);
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
}
