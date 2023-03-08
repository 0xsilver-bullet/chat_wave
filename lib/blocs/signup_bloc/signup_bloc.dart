import 'package:bloc/bloc.dart';
import 'package:chat_wave/data/network/errors/signup_failure.dart';
import 'package:chat_wave/data/repository/auth_repository_impl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final repository = AuthRepositoryImpl();

  SignupBloc() : super(SignupInitial()) {
    on<SignUserUp>(_handleSignUserUp);
  }

  Future<void> _handleSignUserUp(
    SignUserUp event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      final isSignedUp =
          await repository.signup(event.name, event.username, event.password);
      if (isSignedUp) {
        emit(SignedUp());
      } else {
        emit(SignupInitial());
      }
    } on UnknownSignupError catch (_) {
      emit(SignupInitial());
    } on UsernameAlreadyExists catch (_) {
      emit(const SignupFailed(usernameFieldError: 'username already exists'));
    }
  }
}
