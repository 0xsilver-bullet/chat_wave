import 'package:bloc/bloc.dart';
import 'package:chat_wave/auth/data/repository/auth_repository_impl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final repository = AuthRepositoryImpl();

  LoginBloc() : super(LoginInitial()) {
    on<LogUserIn>(_handleLogUserInEvent);
  }

  Future<void> _handleLogUserInEvent(
    LogUserIn event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final isUserLoggedIn =
        await repository.login(event.username, event.password);
    if (isUserLoggedIn) {
      emit(LoggedIn());
    } else {
      emit(LoggingFailed());
    }
  }
}
