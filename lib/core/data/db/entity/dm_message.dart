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

  final String id;
  final String? text;
  final int senderId;
  final int receiverId;
  final int timestamp;
  final bool isOwnMessage;
  final bool seen;

  DmMessageEntity.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        text = map['text'],
        senderId = map['sender_id'],
        receiverId = map['receiver_id'],
        timestamp = map['timestamp'],
        isOwnMessage = map['is_own_message'] == 1 ? true : false,
        seen = map['seen'] == 1 ? true : false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'timestamp': timestamp,
      'is_own_message': isOwnMessage ? 1 : 0,
      'seen': seen ? 1 : 0,
    };
  }
}
