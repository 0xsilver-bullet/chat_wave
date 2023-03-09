part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class NotSignedUp extends SignupState {
  const NotSignedUp({required this.signupFieldsState});

  final SignupFieldsSatate signupFieldsState;

  @override
  List<Object> get props => [signupFieldsState];
}

class SignupLoading extends SignupState {}

class SignedUp extends SignupState {}
