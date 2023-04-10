import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
abstract class ClientEvent {
  const ClientEvent(this.event);

  final String event;

  String toJson();
}

class SendMessageEvent extends ClientEvent {
  const SendMessageEvent({
    required this.channelId,
    required this.text,
    required this.imageUrl,
    required this.provisionalId,
  }) : super('send_message_cli_event');

  final int channelId;
  final String? text;
  final String? imageUrl;
  final String? provisionalId;

  @override
  String toJson() {
    return jsonEncode(
      {
        'event': event,
        'channelId': channelId,
        'text': text,
        'imageUrl': imageUrl,
        'provisionalId': provisionalId,
      },
    );
  }
}

@immutable
class SeenMessageEvent extends ClientEvent {
  const SeenMessageEvent({
    required this.channelId,
    required this.messagesIds,
  }) : super('seen_messages_cli_event');

  final int channelId;
  final List<String> messagesIds;

  @override
  String toJson() {
    return jsonEncode(
      {
        'event': event,
        'channelId': channelId,
        'messagesIds': messagesIds,
      },
    );
  }
}
