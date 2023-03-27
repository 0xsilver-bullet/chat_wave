import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/event/events_bloc/events_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  final int sendChannelId;

  Future<void> _handleSendEvent(
    Send event,
    Emitter<MessageInputState> emit,
  ) async {
    if (event.message.isEmpty) return;
    eventsBloc.add(SendDm(text: event.message, receiverId: sendChannelId));
  }
}
