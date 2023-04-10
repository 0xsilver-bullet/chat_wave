import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Message extends Equatable {
  const Message({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.text,
    required this.imageUrl,
    required this.formattedDate,
    required this.isOwnMessage,
    required this.seen,
  });

  final String id;
  final int channelId;
  final int senderId;
  final String? text;
  final String? imageUrl;
  final String formattedDate;
  final bool isOwnMessage;
  final bool seen;

  @override
  List<Object?> get props => [
        id,
        channelId,
        senderId,
        text,
        imageUrl,
        formattedDate,
        isOwnMessage,
        seen,
      ];
}
