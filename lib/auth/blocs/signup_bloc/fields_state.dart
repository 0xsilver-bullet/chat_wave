import 'package:chat_wave/auth/utils/name.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../utils/password.dart';
import '../../utils/username.dart';

@immutable
class SignupFieldsSatate extends Equatable {
  const SignupFieldsSatate({
    required this.name,
    required this.username,
    required this.password,
    this.nameError,
    this.usernameError,
    this.passwordError,
  });

  static const empty = SignupFieldsSatate(
    name: Name.pure(),
    username: Username.pure(),
    password: Password.pure(),
  );

  final Name name;
  final Username username;
  final Password password;

  // I'm not using the formz error in ui because it will update once user start typing,
  // which is not the behavior I want, validation occur only on submit.
  final String? nameError;
  final String? usernameError;
  final String? passwordError;

  SignupFieldsSatate copyWith({
    Name? name,
    Username? username,
    Password? password,
    String? nameError,
    String? usernameError,
    String? passwordError,
  }) {
    return SignupFieldsSatate(
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      nameError: nameError,
      usernameError: usernameError,
      passwordError: passwordError,
    );
  }

  @override
  List<Object?> get props => [
        name,
        username,
        password,
        usernameError,
        passwordError,
      ];
}
