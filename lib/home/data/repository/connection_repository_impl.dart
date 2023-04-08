import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/mapper/user_info_mapper.dart';
import 'package:chat_wave/home/data/network/secret_api_client.dart';
import 'package:chat_wave/home/domain/error/connect_to_friend_error.dart';
import 'package:chat_wave/home/domain/repository/connection_repository.dart';

class ConnectionRepositoryImpl extends ConnectionRepository {
  ConnectionRepositoryImpl(FriendDao friendDao) : _friendDao = friendDao;

  final FriendDao _friendDao;
  final _api = SecretApiClient();

  @override
  Future<void> connectToFriend(String secret) async {
    final apiResponse = await _api.connectToFriend(secret);
    if (apiResponse.isSuccessful) {
      final friend = apiResponse.data!.toFriendEntity();
      await _friendDao.insert(friend);
    }
    switch (apiResponse.error!.errorCode) {
      case ConnectToFriendError.alreadyConnectedUserCode:
        throw AlreadyFriendsException();
      case ConnectToFriendError.frienshipSecretExpiredCode:
        throw FriendshipSecretExpiredException();
      case ConnectToFriendError.invalidFriendshipSecretCode:
        throw InvalidFrienshipSecretException();
      default:
        throw Exception('Unexpected Error Code');
    }
  }
}
