abstract class FriendRepository {
  Future<void> addFriend(String username);

  /// Requests a frienship secret from API.
  /// It's mainly used to show as a QR code where other user will scan it,
  /// and use to to add the current user as a friend.
  Future<String> generateFriendshipSecret();
}
