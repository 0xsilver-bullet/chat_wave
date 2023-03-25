import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Channel extends Equatable {
  const Channel({
    required this.channelName,
    this.lastMessage,
  });

  final String channelName;
  final String? lastMessage;

  @override
  List<Object?> get props => [channelName, lastMessage];
}
