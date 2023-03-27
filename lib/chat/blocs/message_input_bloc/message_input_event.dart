part of 'message_input_bloc.dart';

abstract class MessageInputEvent extends Equatable {
  const MessageInputEvent();

  @override
  List<Object> get props => [];
}

@immutable
class Send extends MessageInputEvent {
  const Send(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
