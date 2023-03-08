part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

@immutable
class SignUserUp extends SignupEvent {
  const SignUserUp({
    required this.name,
    required this.username,
    required this.password,
  });

  final String name;
  final String username;
  final String password;

  @override
  List<Object> get props => [
        name,
        username,
        password,
      ];
}
