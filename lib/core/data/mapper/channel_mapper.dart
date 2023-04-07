import 'package:chat_wave/core/data/db/entity/channel.dart';
import 'package:chat_wave/core/data/db/util/channel_type.dart';
import 'package:chat_wave/core/data/network/dto/channel_dto.dart';

extension Mapper on ChannelDto {
  ChannelEntity toChannelEntity() {
    return ChannelEntity(
      id: id,
      name: name,
      type: type == 0 ? ChannelType.dm : ChannelType.group,
    );
  }
}
