import 'package:chat_wave/core/domain/model/message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Channel extends Equatable {
  const Channel({
    required this.id,
    required this.name,
    this.lastMessage,
    this.imageUrl,
  });

  final int id;
  final String name;
  final Message? lastMessage;
  final String? imageUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        lastMessage,
        imageUrl,
      ];
}
