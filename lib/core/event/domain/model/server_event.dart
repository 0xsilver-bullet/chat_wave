import 'package:chat_wave/core/data/network/dto/dm_message_dto.dart';
import 'package:chat_wave/core/data/network/dto/user_info_dto.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ServerEvent {
  const ServerEvent(this.event);

  final String event;
}

// To indicate that a message is sent successfully
@immutable
class DmSentEvent extends ServerEvent {
  const DmSentEvent({
    required this.messageDto,
    required this.provisionalId,
  }) : super(DmSentEvent.eventName);

  DmSentEvent.fromJson(Map<String, dynamic> json)
      : messageDto = DmMessageDto.fromJson(json['message']),
        provisionalId = json['provisionalId'],
        super(DmSentEvent.eventName);

  static const eventName = 'dm_sent_event_s_event';

  final DmMessageDto messageDto;
  final String? provisionalId;
}

@immutable
class UpdateDmMessageEvent extends ServerEvent {
  const UpdateDmMessageEvent(this.messageDto)
      : super(UpdateDmMessageEvent.eventName);

  UpdateDmMessageEvent.formJson(Map<String, dynamic> json)
      : messageDto = DmMessageDto.fromJson(json['message']),
        super(UpdateDmMessageEvent.eventName);

  static const eventName = 'update_dm_message_s_event';

  final DmMessageDto messageDto;
}

@immutable
class ConnectedToUserEvent extends ServerEvent {
  const ConnectedToUserEvent(this.user) : super(ConnectedToUserEvent.eventName);

  ConnectedToUserEvent.formJson(Map<String, dynamic> json)
      : user = UserInfoDto.fromJson(json['user']),
        super(UpdateDmMessageEvent.eventName);

  static const eventName = 'connected_to_user_s_event';

  final UserInfoDto user;
}

@immutable
class FriendOnlineStatusEvent extends ServerEvent {
  const FriendOnlineStatusEvent({
    required this.friendId,
    required this.online,
  }) : super(FriendOnlineStatusEvent.eventName);

  FriendOnlineStatusEvent.fromJson(Map<String, dynamic> json)
      : friendId = json['friendId'],
        online = json['online'],
        super(FriendOnlineStatusEvent.eventName);

  static const eventName = 'friend_online_status_s_event';

  final int friendId;
  final bool online;
}

@immutable
class ReceivedDmMessageEvent extends ServerEvent {
  const ReceivedDmMessageEvent(this.messageDto)
      : super(ReceivedDmMessageEvent.eventName);

  ReceivedDmMessageEvent.fromJson(Map<String, dynamic> json)
      : messageDto = DmMessageDto.fromJson(json['message']),
        super(ReceivedDmMessageEvent.eventName);

  static const eventName = 'received_message_s_event';

  final DmMessageDto messageDto;
}
