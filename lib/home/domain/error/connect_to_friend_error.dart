abstract class ConnectToFriendError implements Exception {
  static const int alreadyConnectedUserCode = 6;
  static const int invalidFriendshipSecretCode = 7;
  static const int frienshipSecretExpiredCode = 8;
}

class AlreadyFriendsException extends ConnectToFriendError {}

class InvalidFrienshipSecretException extends ConnectToFriendError {}

class FriendshipSecretExpiredException extends ConnectToFriendError {}
