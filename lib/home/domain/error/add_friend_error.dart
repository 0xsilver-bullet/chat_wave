abstract class AddFriendError implements Exception {
  static const int userNotFound = 3;
  static const int alreadyFriendsCode = 6;
}

class AlreadyFriends extends AddFriendError {}

class UserNotFound extends AddFriendError {}
