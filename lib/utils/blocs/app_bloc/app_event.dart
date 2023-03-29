part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

@immutable
class InitializeAppState extends AppEvent {}

@immutable
class ToggleForceDarkMode extends AppEvent {}

@immutable
class UserLoggedIn extends AppEvent {}

@immutable
class Logout extends AppEvent {}

@immutable
class UserInfoChanged extends AppEvent {
  const UserInfoChanged(this.userInfo);

  final UserInfo userInfo;

  @override
  List<Object> get props => [userInfo];
}
