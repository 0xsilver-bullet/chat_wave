part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignedUp extends SignupState {}

class SignupFailed extends SignupState {
  const SignupFailed({required this.usernameFieldError});

  final String usernameFieldError;

  @override
  List<Object> get props => [usernameFieldError];
}
