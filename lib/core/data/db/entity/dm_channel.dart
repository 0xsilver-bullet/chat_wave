import 'package:chat_wave/core/data/db/entity/dm_message.dart';

class DmChannelEntity {
  DmChannelEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.profilePicUrl,
    required this.lastMessage,
  });

  final int id;
  final String name;
  final String username;
  final String? profilePicUrl;
  final DmMessageEntity? lastMessage;

  DmChannelEntity.fromMap(
    Map<String, dynamic> map,
    DmMessageEntity? lastDm,
  )   : id = map['channel_id'],
        name = map['name'],
        username = map['username'],
        profilePicUrl = map['profile_pic_url'],
        lastMessage = lastDm;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'profile_pic_url': profilePicUrl,
      'last_message_id': lastMessage?.id,
    };
  }
}
