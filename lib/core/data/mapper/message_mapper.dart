import 'package:chat_wave/core/data/db/entity/message.dart';
import 'package:chat_wave/core/data/network/dto/message_dto.dart';

extension Mapper on MessageDto {
  MessageEntity toMessageEntity(bool isOwnMessage) {
    return MessageEntity(
      id: id,
      text: text,
      imageUrl: imageUrl,
      channelId: channelId,
      senderId: senderId,
      seenBy: seenBy,
      timestamp: timestamp,
      isOwnMessage: isOwnMessage,
    );
  }
}
