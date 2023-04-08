import 'package:chat_wave/core/data/db/dao/channel_full_dao.dart';
import 'package:chat_wave/core/data/db/util/channel_type.dart';
import 'package:chat_wave/core/data/mapper/friend_mapper.dart';
import 'package:chat_wave/core/domain/model/channel.dart';
import 'package:chat_wave/core/domain/model/dm_channel.dart';
import 'package:chat_wave/core/domain/model/group_channel.dart';
import 'package:chat_wave/core/domain/online_status_provider.dart';
import 'package:chat_wave/home/data/mapper/channel_full_mapper.dart';
import 'package:chat_wave/home/data/mapper/message_mapper.dart';
import 'package:chat_wave/home/data/network/channels_api_client.dart';
import 'package:chat_wave/home/domain/repository/channel_repository.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

class ChannelRepositoryImpl extends ChannelRepository {
  ChannelRepositoryImpl(
    ChannelFullDao channelFullDao,
    OnlineStatusProvider onlineStatusProvider,
  )   : _channelFullDao = channelFullDao,
        _onlineStatusProvider = onlineStatusProvider;

  final ChannelFullDao _channelFullDao;
  final OnlineStatusProvider _onlineStatusProvider;
  final _api = ChannelsApiClient();

  @override
  Stream<List<Channel>> get watchChannels => CombineLatestStream.combine2(
        _channelFullDao.watchChannels,
        _onlineStatusProvider.onlineUsersStream,
        (channels, onlineUsersIds) {
          final result = channels.map(
            (channelData) {
              if (channelData.channel.type == ChannelType.dm) {
                final friend = channelData.channelUsers.firstOrNull;
                return DmChannel(
                  friendInfo: friend!.toUserInfo(),
                  online: onlineUsersIds.contains(friend.id),
                  channelId: channelData.channel.id,
                  lastMessage: channelData.lastMessage?.toMessage(),
                );
              } else {
                // Currently there is only group channels and dm channels
                return GroupChannel(
                  friends: channelData.channelUsers
                      .map((friendEntity) => friendEntity.toUserInfo())
                      .toList(),
                  channelId: channelData.channel.id,
                  channelName:
                      channelData.channel.name!, // it can't be null if group
                  channelImageUrl: null, // TODO: Not supported yet in backend
                  lastMessage: channelData.lastMessage?.toMessage(),
                );
              }
            },
          ).toList();
          return result;
        },
      );

  @override
  Future<void> sync() async {
    final apiResponse = await _api.fetchUserChannels();
    if (!apiResponse.isSuccessful) return;
    final channels = apiResponse.data!
        .map((channelDto) => channelDto.toFullChannelEntity())
        .toList();
    await _channelFullDao.insertAll(channels);
  }
}
