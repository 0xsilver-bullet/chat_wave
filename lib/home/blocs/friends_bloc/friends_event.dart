part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadedUserFriends extends FriendsEvent {
  const LoadedUserFriends(this.friends);

  final List<Friend> friends;

  @override
  List<Object> get props => [friends];
}
