part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadedMessages extends MessagesEvent {
  const LoadedMessages(this.messages);

  final List<Message> messages;

  @override
  List<Object> get props => [messages];
}
