import 'package:flutter/foundation.dart';

import 'channel.dart';
import 'message.dart';

@immutable
class DmChannel extends Channel {
  const DmChannel({
    required this.friendName,
    required this.friendId,
    required this.online,
    required Message? lastMessage,
  }) : super(channelName: friendName, lastMessage: lastMessage);

  final int friendId;
  final String friendName;
  final bool online;

  @override
  List<Object> get props => [friendId, friendName, online];
}
