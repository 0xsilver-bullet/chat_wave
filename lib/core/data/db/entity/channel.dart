import 'package:chat_wave/core/data/db/util/channel_type.dart';

class ChannelEntity {
  ChannelEntity({
    required this.id,
    required this.name,
    required this.type,
  });

  final int id;
  final String? name;
  final ChannelType type; // will map to an int in the table column

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
    };
  }
}
