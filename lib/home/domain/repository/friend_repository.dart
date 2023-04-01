import 'package:chat_wave/core/data/db/entity/dm_channel.dart';

abstract class FriendRepository {
  Stream<List<DmChannelEntity>> watchDmChannels();

  Future<void> addFriend(String username);
}
