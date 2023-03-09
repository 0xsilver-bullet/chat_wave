import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../utils/password.dart';
import '../../utils/username.dart';

@immutable
class LoginFieldsState extends Equatable {
  const LoginFieldsState({
    required this.username,
    required this.password,
    this.usernameError,
    this.passwordError,
  });

  static const empty = LoginFieldsState(
    username: Username.pure(),
    password: Password.pure(),
  );

  final Username username;
  final Password password;

  // I'm not using the formz error in ui because it will update once user start typing,
  // which is not the behavior I want, validation occur only on submit.
  final String? usernameError;
  final String? passwordError;

  LoginFieldsState copyWith({
    Username? username,
    Password? password,
    String? usernameError,
    String? passwordError,
  }) {
    return LoginFieldsState(
      username: username ?? this.username,
      password: password ?? this.password,
      usernameError: usernameError,
      passwordError: passwordError,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        usernameError,
        passwordError,
      ];
}
