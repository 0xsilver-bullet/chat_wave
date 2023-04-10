part of 'events_bloc.dart';

@immutable
abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

// Start initialization process
@immutable
class Initialize extends EventsEvent {}

// Pauses listening to events and closes connection with server.
@immutable
class Pause extends EventsEvent {}

// resumes listening and events and connecting with server.
@immutable
class Resume extends EventsEvent {}

@immutable
class SendMessage extends EventsEvent {
  const SendMessage({
    required this.channelId,
    required this.text,
    required this.provisionalId,
  });

  final int channelId;
  final String text;
  final String? provisionalId;
}
