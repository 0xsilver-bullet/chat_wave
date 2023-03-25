import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Message extends Equatable {
  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.formattedDate,
    required this.isOwnMessage,
  });

  final String id;
  final String senderId;
  final String? text;
  final String formattedDate;
  final bool isOwnMessage;

  @override
  List<Object?> get props => [
        id,
        senderId,
        text,
        formattedDate,
        isOwnMessage,
      ];
}
