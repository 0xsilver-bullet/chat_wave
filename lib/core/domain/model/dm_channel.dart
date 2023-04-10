import 'package:chat_wave/core/domain/model/user_info.dart';
import 'package:flutter/foundation.dart';

import 'channel.dart';
import 'message.dart';

@immutable
class DmChannel extends Channel {
  DmChannel({
    required this.friendInfo,
    required this.online,
    required int channelId,
    required Message? lastMessage,
  }) : super(
          id: channelId,
          name: friendInfo.name,
          lastMessage: lastMessage,
          imageUrl: friendInfo.profilePicUrl,
        );

  final UserInfo friendInfo;
  final bool online;

  DmChannel copyWith({
    int? channelId,
    UserInfo? friendInfo,
    bool? online,
    Message? lastMessage,
  }) {
    return DmChannel(
      channelId: channelId ?? id,
      friendInfo: friendInfo ?? this.friendInfo,
      online: online ?? this.online,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  List<Object?> get props => super.props
    ..addAll([
      friendInfo,
      online,
    ]);
}
