part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState({
    required this.forceDarkMode,
  });

  final bool forceDarkMode;

  @override
  List<Object> get props => [forceDarkMode];
}

@immutable
class LoadingAppState extends AppState {
  const LoadingAppState() : super(forceDarkMode: false);
}

@immutable
class AppAuthenticated extends AppState {
  final UserInfo userInfo;

  const AppAuthenticated(bool forceDarkMode, this.userInfo)
      : super(forceDarkMode: forceDarkMode);
}

@immutable
class AppNeedsAuthentication extends AppState {
  const AppNeedsAuthentication(bool forceDarkMode)
      : super(forceDarkMode: forceDarkMode);
}
