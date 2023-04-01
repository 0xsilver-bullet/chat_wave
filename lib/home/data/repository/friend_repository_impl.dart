import 'package:chat_wave/core/data/db/dao/dm_channel_dao.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/entity/dm_channel.dart';
import 'package:chat_wave/home/data/mapper/friend_mapper.dart';
import 'package:chat_wave/home/data/network/friends_api_client.dart';
import 'package:chat_wave/home/domain/error/add_friend_error.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  FriendRepositoryImpl(
    FriendDao friendDao,
    DmChannelDao dmChannelDao,
  )   : _friendDao = friendDao,
        _dmChannelDao = dmChannelDao {
    _init();
  }

  final api = FriendsApiClient();
  final FriendDao _friendDao;
  final DmChannelDao _dmChannelDao;

  @override
  Stream<List<DmChannelEntity>> watchDmChannels() =>
      _dmChannelDao.watchDmChannels;

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
      final channels = apiResponse.data!
          .map(
            (networkFriend) => networkFriend.toChannel(),
          )
          .toList();
      _dmChannelDao.insertAll(channels);
    }
  }
}
