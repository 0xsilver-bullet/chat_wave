import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/event/domain/event_repository.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(NotInitialized()) {
    on<Initialize>(_handleInitializeEvent);
    on<Pause>(_handlePauseEvent);
    on<Resume>(_handleResumeEvent);
    add(Initialize());
  }

  final repository = locator<EventRepository>();

  Future<void> _handleInitializeEvent(
    Initialize event,
    Emitter<EventsState> emit,
  ) async {
    emit(Initializing());
    await repository.initialize();
    emit(Initialized());
  }

  Future<void> _handlePauseEvent(
    Pause event,
    Emitter<EventsState> emit,
  ) async {
    repository.clear();
    emit(NotInitialized());
  }

  Future<void> _handleResumeEvent(
    Resume event,
    Emitter<EventsState> emit,
  ) async {
    emit(Initializing());
    repository.initialize();
    emit(Initialized());
  }

  @override
  Future<void> close() {
    repository.clear();
    return super.close();
  }
}
