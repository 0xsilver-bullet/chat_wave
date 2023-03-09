part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class NameFieldChanged extends SignupEvent {
  const NameFieldChanged([this.value = '']);

  final String value;

  @override
  List<Object> get props => [value];
}

class UsernameFieldChanged extends SignupEvent {
  const UsernameFieldChanged([this.value = '']);

  final String value;

  @override
  List<Object> get props => [value];
}

class PasswordFieldChanged extends SignupEvent {
  const PasswordFieldChanged([this.value = '']);

  final String value;

  @override
  List<Object> get props => [value];
}

class Submit extends SignupEvent {}
