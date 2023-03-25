part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

@immutable
class MessagesList extends MessagesState {
  const MessagesList(this.messages);

  final List<Message> messages;

  @override
  List<Object> get props => [messages];
}
