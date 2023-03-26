part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class NotInitialized extends EventsState {}

class Initializing extends EventsState {}

class Initialized extends EventsState {}
