import 'package:chat_wave/core/data/db/entity/message.dart';
import 'package:chat_wave/core/domain/model/message.dart';
import 'package:intl/intl.dart';

extension Mapper on MessageEntity {
  Message toMessage() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formattedDate = DateFormat('hh::mm a').format(dateTime);
    return Message(
      id: id,
      channelId: channelId,
      text: text,
      imageUrl: imageUrl,
      formattedDate: formattedDate,
      senderId: senderId,
      seen: seenBy.length > 1,
      isOwnMessage: isOwnMessage,
    );
  }
}
