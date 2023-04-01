import 'package:chat_wave/core/data/db/entity/dm_message.dart';
import 'package:chat_wave/core/domain/model/dm_message.dart';
import 'package:timeago/timeago.dart' as timeago;

extension Mapper on DmMessageEntity {
  DmMessage toDmMessage() {
    final messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DmMessage(
      formattedDate: timeago.format(messageTime),
      id: id,
      isOwnMessage: isOwnMessage,
      senderId: senderId,
      text: text,
      receiverId: receiverId,
      seen: seen,
    );
  }
}
