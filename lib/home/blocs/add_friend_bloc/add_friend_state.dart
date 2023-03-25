part of 'add_friend_bloc.dart';

@immutable
abstract class AddFriendState extends Equatable {
  const AddFriendState({required this.username, this.fieldError});

  final String username;
  final String? fieldError;

  @override
  List<Object?> get props => [username, fieldError];
}

@immutable
class AddFriendIdle extends AddFriendState {
  const AddFriendIdle({required String username, String? fieldError})
      : super(
          username: username,
          fieldError: fieldError,
        );
}

@immutable
class Loading extends AddFriendState {
  const Loading(String username) : super(username: username);
}

class Added extends AddFriendState {
  const Added() : super(username: '');
}
