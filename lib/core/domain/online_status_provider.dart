abstract class OnlineStatusProvider {
  // It marks this user as an online user and will update the online users stream.
  void markUserAsOnline(int userId);

  void markUserAsOffline(int userId);

  Stream<List<int>> get onlineUsersStream;

  void dispose();
}
