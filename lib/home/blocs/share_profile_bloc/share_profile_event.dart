part of 'share_profile_bloc.dart';

@immutable
abstract class ShareProfileEvent extends Equatable {
  const ShareProfileEvent();

  @override
  List<Object> get props => [];
}

@immutable
class GenerateFrienshipSecret extends ShareProfileEvent {}
