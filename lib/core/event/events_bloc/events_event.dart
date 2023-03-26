part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

// Start initialization process
class Initialize extends EventsEvent {}

// Pauses listening to events and closes connection with server.
class Pause extends EventsEvent {}

// resumes listening and events and connecting with server.
class Resume extends EventsEvent {}
