import 'package:chat_wave/core/data/db/entity/channel.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/core/data/db/entity/message.dart';

class ChannelFullEntity {
  ChannelFullEntity({
    required this.channel,
    required this.lastMessage,
    required this.channelUsers,
  });

  final ChannelEntity channel;
  final MessageEntity? lastMessage;
  final List<FriendEntity> channelUsers;
}
