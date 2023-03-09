part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class NotLoggedIn extends LoginState {
  const NotLoggedIn({required this.loginFieldsState});

  final LoginFieldsState loginFieldsState;

  @override
  List<Object> get props => [loginFieldsState];
}

class LoginLoading extends LoginState {}

class LoggedIn extends LoginState {}
