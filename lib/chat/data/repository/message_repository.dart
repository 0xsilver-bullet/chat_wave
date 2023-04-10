import 'package:chat_wave/core/domain/model/message.dart';

abstract class MessageRepository {
  Stream<List<Message>> watchChannelMessages(int channelId);

  // saves message to local db only
  // it doesn't send the message.
  // to send a message you need to emit it as an event to the events bloc
  Future<void> saveMessage(
    String text,
    int channelId,
    String provisionalId,
  );
}
