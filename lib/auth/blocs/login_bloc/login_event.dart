part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class UsernameFieldChanged extends LoginEvent {
  const UsernameFieldChanged([this.value = '']);

  final String value;

  @override
  List<Object> get props => [value];
}

class PasswordFieldChanged extends LoginEvent {
  const PasswordFieldChanged([this.value = '']);

  final String value;

  @override
  List<Object> get props => [value];
}

class Submit extends LoginEvent {}
