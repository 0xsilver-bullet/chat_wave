import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/domain/model/message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(const MessagesList([])) {
    on<LoadedMessages>((event, emit) {
      emit(MessagesList(event.messages));
    });
  }
}
