import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
abstract class ClientEvent {
  const ClientEvent(this.event);

  final String event;

  String toJson();
}

class SendDmMessageEvent extends ClientEvent {
  const SendDmMessageEvent({
    required this.text,
    required this.receiverId,
    required this.provisionalId,
  }) : super('send_dm_message_cli_event');

  final String text;
  final int receiverId;
  final String? provisionalId;

  @override
  String toJson() {
    return jsonEncode(
      {
        'event': event,
        'text': text,
        'receiverId': receiverId,
        'provisionalId': provisionalId,
      },
    );
  }
}

@immutable
class SeenDmMessageEvent extends ClientEvent {
  const SeenDmMessageEvent({required this.messageId})
      : super('seen_dm_message_cli_event');

  final String messageId;

  @override
  String toJson() {
    return jsonEncode(
      {
        'event': event,
        'messageId': messageId,
      },
    );
  }
}
