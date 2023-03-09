import 'package:chat_wave/auth/utils/name.dart';
import 'package:chat_wave/auth/utils/password.dart';
import 'package:chat_wave/auth/utils/username.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../data/repository/auth_repository_impl.dart';
import '../../domain/errors/signup_failure.dart';
import 'fields_state.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final repository = AuthRepositoryImpl();

  SignupBloc()
      : super(const NotSignedUp(signupFieldsState: SignupFieldsSatate.empty)) {
    on<Submit>(_handleSubmitEvent);
    on<NameFieldChanged>(_handleNameFieldChanged);
    on<UsernameFieldChanged>(_handleUsernameFieldChagned);
    on<PasswordFieldChanged>(_handlePasswordFieldChanged);
  }

  Future<void> _handleNameFieldChanged(
    NameFieldChanged event,
    Emitter<SignupState> emit,
  ) async {
    if (state is SignupLoading || state is SignedUp) {
      return;
    }
    final current = (state as NotSignedUp).signupFieldsState;
    emit(
      NotSignedUp(
        signupFieldsState: current.copyWith(
          name: Name.dirty(event.value),
          usernameError: current.usernameError,
          passwordError: current.passwordError,
        ),
      ),
    );
  }

  Future<void> _handleUsernameFieldChagned(
    UsernameFieldChanged event,
    Emitter<SignupState> emit,
  ) async {
    if (state is SignupLoading || state is SignedUp) {
      return;
    }
    final current = (state as NotSignedUp).signupFieldsState;
    emit(
      NotSignedUp(
        signupFieldsState: current.copyWith(
          username: Username.dirty(event.value),
          nameError: current.nameError,
          passwordError: current.passwordError,
        ),
      ),
    );
  }

  Future<void> _handlePasswordFieldChanged(
    PasswordFieldChanged event,
    Emitter<SignupState> emit,
  ) async {
    if (state is SignupLoading || state is SignedUp) {
      return;
    }
    final current = (state as NotSignedUp).signupFieldsState;
    emit(
      NotSignedUp(
        signupFieldsState: current.copyWith(
          password: Password.dirty(event.value),
          nameError: current.nameError,
          usernameError: current.usernameError,
        ),
      ),
    );
  }

  Future<void> _handleSubmitEvent(
    Submit event,
    Emitter<SignupState> emit,
  ) async {
    if (state is! NotSignedUp) {
      return;
    }
    final currentFieldsState = (state as NotSignedUp).signupFieldsState;
    emit(SignupLoading());
    if (!Formz.validate(
      [
        currentFieldsState.name,
        currentFieldsState.username,
        currentFieldsState.password,
      ],
    )) {
      emit(
        NotSignedUp(
          signupFieldsState: currentFieldsState.copyWith(
            nameError: currentFieldsState.name.error,
            usernameError: currentFieldsState.username.error,
            passwordError: currentFieldsState.password.error,
          ),
        ),
      );
      return;
    }
    final name = currentFieldsState.name.value;
    final username = currentFieldsState.username.value;
    final password = currentFieldsState.password.value;
    try {
      final isSignedUp = await repository.signup(name, username, password);
      if (isSignedUp) {
        emit(SignedUp());
      }
    } on UnknownSignupError catch (_) {
      emit(NotSignedUp(signupFieldsState: currentFieldsState));
    } on UsernameAlreadyExists catch (_) {
      emit(
        NotSignedUp(
          signupFieldsState: currentFieldsState.copyWith(
            usernameError: 'username already exists',
          ),
        ),
      );
    }
  }
}
