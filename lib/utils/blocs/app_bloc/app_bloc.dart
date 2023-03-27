import 'package:bloc/bloc.dart';
import 'package:chat_wave/auth/domain/repository/auth_repository.dart';
import 'package:chat_wave/core/domain/app_preferences.dart';

import 'package:chat_wave/core/domain/token_manager.dart';
import 'package:chat_wave/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const LoadingAppState()) {
    on<InitializeAppState>(_handleInitializingAppState);
    on<ToggleForceDarkMode>(_handleToggleForceDarkMode);
    on<Logout>(_handleLogoutEvent);
    add(InitializeAppState());
  }

  final _tokenManager = locator<TokenManager>();
  final _prefs = locator<AppPreferences>();
  final _authRepo = locator<AuthRepository>();

  Future<void> _handleInitializingAppState(
    InitializeAppState event,
    Emitter<AppState> emit,
  ) async {
    final hasRefreshToken = _tokenManager.refreshToken != null;
    final forceDarkmode = await _prefs.getForceDarkMode();
    if (hasRefreshToken) {
      emit(AppAuthenticated(forceDarkmode));
    } else {
      emit(AppNeedsAuthentication(forceDarkmode));
    }
  }

  Future<void> _handleToggleForceDarkMode(
    ToggleForceDarkMode event,
    Emitter<AppState> emit,
  ) async {
    final currentValue = state.forceDarkMode;
    await _prefs.setForceDarkMode(!currentValue);
    // emitting authenticated directly because user will not be able to toggle this
    // while he is not authenticated
    emit(AppAuthenticated(!currentValue));
  }

  Future<void> _handleLogoutEvent(Logout event, Emitter<AppState> emit) async {
    final loggedOut = await _authRepo.logout();
    if (!loggedOut) {
      return;
    }
    await _tokenManager.deleteTokens();
    emit(AppNeedsAuthentication(state.forceDarkMode));
  }
}
