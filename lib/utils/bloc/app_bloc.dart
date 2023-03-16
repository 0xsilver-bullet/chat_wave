import 'package:bloc/bloc.dart';

import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(LoadingAppState()) {
    on<InitializeAppState>(_handleInitializingAppState);
    add(InitializeAppState());
  }

  final _tokenManager = locator<TokenManager>();

  Future<void> _handleInitializingAppState(
    InitializeAppState event,
    Emitter<AppState> emit,
  ) async {
    final hasRefreshToken = _tokenManager.refreshToken != null;
    if (hasRefreshToken) {
      emit(AppAuthenticated());
    } else {
      emit(AppNeedsAuthentication());
    }
  }
}
