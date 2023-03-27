part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class InitializeAppState extends AppEvent {}

class ToggleForceDarkMode extends AppEvent {}

class Logout extends AppEvent {}
