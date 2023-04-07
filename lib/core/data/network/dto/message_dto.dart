class MessageDto {
  MessageDto({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.channelId,
    required this.senderId,
    required this.seenBy,
    required this.timestamp,
  });

  MessageDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        imageUrl = json['imageUrl'],
        channelId = json['channelId'],
        senderId = json['senderId'],
        seenBy = json['seenBy'],
        timestamp = json['timestamp'];

  final String id;
  final String? text;
  final String? imageUrl;
  final int channelId;
  final int senderId;
  final List<int> seenBy;
  final int timestamp;
}
