part of 'share_profile_bloc.dart';

@immutable
abstract class ShareProfileState extends Equatable {
  const ShareProfileState();

  @override
  List<Object> get props => [];
}

@immutable
class NoFriendshipSecret extends ShareProfileState {
  const NoFriendshipSecret();
}

@immutable
class LoadingSecret extends ShareProfileState {}

@immutable
class LoadedSecret extends ShareProfileState {
  const LoadedSecret(this.secret);

  final String secret;
}

@immutable
class FailedToLoad extends ShareProfileState {}
