part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

@immutable
class FriendsList extends FriendsState {
  const FriendsList(this.friends);

  final List<Friend> friends;

  @override
  List<Object> get props => [friends];
}
