import 'package:chat_wave/core/data/network/dto/channel_dto.dart';
import 'package:chat_wave/core/data/network/dto/message_dto.dart';
import 'package:chat_wave/core/data/network/dto/user_info_dto.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ServerEvent {
  const ServerEvent(this.event);

  final String event;

  factory ServerEvent.parse(Map<String, dynamic> json) {
    final eventName = json['event'];
    switch (eventName) {
      case MessageSentEvent.eventName:
        return MessageSentEvent.fromJson(json);

      case UpdateMessagesEvent.eventName:
        return UpdateMessagesEvent.formJson(json);

      case ConnectedToUserEvent.eventName:
        return ConnectedToUserEvent.formJson(json);

      case FriendOnlineStatusEvent.eventName:
        return FriendOnlineStatusEvent.fromJson(json);

      case ReceivedMessageEvent.eventName:
        return ReceivedMessageEvent.fromJson(json);

      case AddedToChannel.eventName:
        return AddedToChannel.fromJson(json);

      default:
        throw Exception('Unexpected event');
    }
  }
}

// To indicate that a message is sent successfully
@immutable
class MessageSentEvent extends ServerEvent {
  const MessageSentEvent({
    required this.messageDto,
    required this.provisionalId,
  }) : super(MessageSentEvent.eventName);

  MessageSentEvent.fromJson(Map<String, dynamic> json)
      : messageDto = MessageDto.fromJson(json['message']),
        provisionalId = json['provisionalId'],
        super(MessageSentEvent.eventName);

  static const eventName = 'message_event_s_event';

  final MessageDto messageDto;
  final String? provisionalId;
}

@immutable
class UpdateMessagesEvent extends ServerEvent {
  const UpdateMessagesEvent(this.updatedMessages)
      : super(UpdateMessagesEvent.eventName);

  UpdateMessagesEvent.formJson(Map<String, dynamic> json)
      : updatedMessages = (json['messages'] as List)
            .map((msgJson) => MessageDto.fromJson(msgJson))
            .toList(),
        super(UpdateMessagesEvent.eventName);

  static const eventName = 'update_messages_s_event';

  final List<MessageDto> updatedMessages;
}

@immutable
class ConnectedToUserEvent extends ServerEvent {
  const ConnectedToUserEvent(this.user) : super(ConnectedToUserEvent.eventName);

  ConnectedToUserEvent.formJson(Map<String, dynamic> json)
      : user = UserInfoDto.fromJson(json['user']),
        super(ConnectedToUserEvent.eventName);

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
class ReceivedMessageEvent extends ServerEvent {
  const ReceivedMessageEvent(this.messageDto)
      : super(ReceivedMessageEvent.eventName);

  ReceivedMessageEvent.fromJson(Map<String, dynamic> json)
      : messageDto = MessageDto.fromJson(json['message']),
        super(ReceivedMessageEvent.eventName);

  static const eventName = 'received_message_s_event';

  final MessageDto messageDto;
}

@immutable
class AddedToChannel extends ServerEvent {
  const AddedToChannel(this.channelDto) : super(AddedToChannel.eventName);

  AddedToChannel.fromJson(Map<String, dynamic> json)
      : channelDto = ChannelDto.fromJson(json['channel']),
        super(AddedToChannel.eventName);

  static const eventName = 'added_to_channel_s_event';

  final ChannelDto channelDto;
}
