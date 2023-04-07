import 'package:chat_wave/core/domain/model/message.dart';
import 'package:chat_wave/core/domain/model/user_info.dart';

import 'channel.dart';

class GroupChannel extends Channel {
  const GroupChannel({
    required this.friends,
    required int channelId,
    required String channelName,
    required String? channelImageUrl,
    required Message? lastMessage,
  }) : super(
          id: channelId,
          name: channelName,
          imageUrl: channelImageUrl,
          lastMessage: lastMessage,
        );

  final List<UserInfo> friends;

  GroupChannel copyWith({
    List<UserInfo>? friends,
    int? channelId,
    String? channelName,
    String? channelImageUrl,
    Message? lastMessage,
  }) {
    return GroupChannel(
      friends: friends ?? this.friends,
      channelId: channelId ?? id,
      channelName: channelName ?? name,
      channelImageUrl: channelImageUrl ?? imageUrl,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  List<Object?> get props => super.props
    ..addAll([
      friends,
    ]);
}
