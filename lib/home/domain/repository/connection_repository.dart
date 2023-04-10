/// Used to connect to other users [and group channels in future]
abstract class ConnectionRepository {
  Future<void> connectToFriend(String secret);
}
