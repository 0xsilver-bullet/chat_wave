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
    required String? profilePicUrl,
  }) : super(
          channelId: friendId,
          channelName: friendName,
          lastMessage: lastMessage,
          channelImageUrl: profilePicUrl,
        );

  final int friendId;
  final String friendName;
  final bool online;

  DmChannel copyWith({
    String? friendName,
    int? friendId,
    bool? online,
    Message? lastMessage,
    String? profilePicUrl,
  }) {
    return DmChannel(
      friendName: friendName ?? this.friendName,
      friendId: friendId ?? this.friendId,
      online: online ?? this.online,
      lastMessage: lastMessage ?? this.lastMessage,
      profilePicUrl: profilePicUrl ?? channelImageUrl,
    );
  }

  @override
  List<Object> get props => [friendId, friendName, online];
}
