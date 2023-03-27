import 'package:chat_wave/core/domain/model/dm_message.dart';

abstract class DmRepository {
  Stream<List<DmMessage>> watchFriendDms(int friendId);

  // saves message to local db only
  // it doesn't send the message.
  // to send a message you need to emit it as an event to the events bloc
  Future<void> saveMessage(
    String text,
    int receiverId,
    String provisionalId,
  );
}
