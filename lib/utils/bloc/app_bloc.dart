import 'package:bloc/bloc.dart';
import 'package:chat_wave/core/data/secure_local_storage_impl.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(LoadingAppState()) {
    on<InitializeAppState>(_handleInitializingAppState);
    add(InitializeAppState());
  }

  final storage = SecureStorageImpl();

  Future<void> _handleInitializingAppState(
    InitializeAppState event,
    Emitter<AppState> emit,
  ) async {
    final hasRefreshToken = await storage.hasRefreshToken();
    if (hasRefreshToken) {
      emit(AppAuthenticated());
    } else {
      emit(AppNeedsAuthentication());
    }
  }
}
