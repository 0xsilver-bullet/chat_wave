import 'package:floor/floor.dart';

@entity
class DmMessageEntity {
  DmMessageEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.isOwnMessage,
    required this.seen,
  });

  @PrimaryKey(autoGenerate: false)
  final String id;

  final String? text;

  @ColumnInfo(name: 'sender_id')
  final int senderId;

  @ColumnInfo(name: 'receiver_id')
  final int receiverId;

  final int timestamp;

  @ColumnInfo(name: 'is_own_message')
  final bool isOwnMessage;

  final bool seen;
}
