part of 'add_friend_bloc.dart';

abstract class AddFriendEvent extends Equatable {
  const AddFriendEvent();

  @override
  List<Object> get props => [];
}

@immutable
class UsernameFieldChanged extends AddFriendEvent {
  const UsernameFieldChanged(this.username);

  final String username;

  @override
  List<Object> get props => [];
}

@immutable
class AddFriend extends AddFriendEvent {
  const AddFriend();
}
