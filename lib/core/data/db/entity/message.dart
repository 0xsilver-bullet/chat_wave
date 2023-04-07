class MessageEntity {
  MessageEntity({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.channelId,
    required this.senderId,
    required this.seenBy,
    required this.timestamp,
    required this.isOwnMessage,
  });

  MessageEntity.froMap(Map<String, dynamic> map)
      : id = map['id'],
        text = map['text'],
        imageUrl = map['image_url'],
        channelId = map['channel_id'],
        senderId = map['sender_id'],
        seenBy = (map['seen_by'] as String)
            .split(',')
            .map((id) => int.parse(id))
            .toList(),
        timestamp = map['timestamp'],
        isOwnMessage = map['is_own_message'] == 1 ? true : false;

  factory MessageEntity.createLocalMessage(
    String provisionalId,
    String text,
    int channelId,
    int userId,
  ) {
    return MessageEntity(
      id: provisionalId,
      text: text,
      imageUrl: null,
      channelId: channelId,
      senderId: userId,
      seenBy: [],
      timestamp: DateTime.now().millisecondsSinceEpoch,
      isOwnMessage: true,
    );
  }

  final String id;
  final String? text;
  final String? imageUrl;
  final int channelId;
  final int senderId;
  final List<int> seenBy;
  final int timestamp;
  final bool isOwnMessage;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'image_url': imageUrl,
      'channel_id': channelId,
      'sender_id': senderId,
      'seen_by': seenBy.join(','),
      'timestamp': timestamp,
      'is_own_message': isOwnMessage ? 1 : 0,
    };
  }
}
