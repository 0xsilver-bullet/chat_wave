import 'package:bloc/bloc.dart';
import 'package:chat_wave/chat/data/repository/message_repository.dart';
import 'package:chat_wave/core/event/events_bloc/events_bloc.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'message_input_event.dart';
part 'message_input_state.dart';

class MessageInputBloc extends Bloc<MessageInputEvent, MessageInputState> {
  MessageInputBloc({
    required this.eventsBloc,
    required this.sendChannelId,
  }) : super(const MessageInputState()) {
    on<Send>(_handleSendEvent);
  }

  final EventsBloc eventsBloc;
  final _messageRepository = locator<MessageRepository>();
  final int sendChannelId;
  final _uuId = const Uuid();

  Future<void> _handleSendEvent(
    Send event,
    Emitter<MessageInputState> emit,
  ) async {
    if (event.message.isEmpty) return;
    final provisionalId = _uuId.v4();
    _messageRepository.saveMessage(event.message, sendChannelId, provisionalId);
    eventsBloc.add(
      SendDm(
        text: event.message,
        receiverId: sendChannelId,
        provisionalId: provisionalId,
      ),
    );
  }
}
