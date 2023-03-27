class DmMessageDto {
  const DmMessageDto({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.seen,
    required this.timestamp,
    required this.id,
  });

  DmMessageDto.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        senderId = json['senderId'],
        receiverId = json['receiverId'],
        seen = json['seen'],
        timestamp = json['timestamp'],
        id = json['id'];

  final String text;
  final int senderId;
  final int receiverId;
  final bool seen;
  final int timestamp;
  final String id;
}
