import 'package:chat_wave/core/domain/model/message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Channel extends Equatable {
  const Channel({
    required this.channelName,
    this.lastMessage,
    this.channelImageUrl,
  });

  final String channelName;
  final Message? lastMessage;
  final String? channelImageUrl;

  @override
  List<Object?> get props => [channelName, lastMessage, channelImageUrl];
}
