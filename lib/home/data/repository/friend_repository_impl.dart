import 'package:chat_wave/home/data/network/friends_api_client.dart';
import 'package:chat_wave/home/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  final _api = FriendsApiClient();

  @override
  Future<String> generateFriendshipSecret() async {
    final apiResponse = await _api.requestFriendshipSecret();
    if (!apiResponse.isSuccessful) throw Exception('Can\'t fetch api secret');
    return apiResponse.data!;
  }
}
