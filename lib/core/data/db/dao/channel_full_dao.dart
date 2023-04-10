import 'dart:async';

import 'package:chat_wave/core/data/db/dao/channel_dao.dart';
import 'package:chat_wave/core/data/db/dao/channel_membership_dao.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/entity/channel.dart';
import 'package:chat_wave/core/data/db/entity/channel_membership.dart';
import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/core/data/db/entity/message.dart';
import 'package:chat_wave/core/data/db/util/channel_type.dart';
import 'package:chat_wave/utils/list_ext.dart';
import 'package:collection/collection.dart';

import 'package:chat_wave/core/data/db/entity/channel_full.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

/// This is mainly used to query the channels with their full data like the last message
/// and the users in this channel.
class ChannelFullDao {
  ChannelFullDao({
    required Database db,
    required FriendDao friendDao,
    required ChannelDao channelDao,
    required ChannelMembershipDao channelMembershipDao,
  })  : _db = db,
        _friendDao = friendDao,
        _channelDao = channelDao,
        _channelMembershipDao = channelMembershipDao {
    _streamController = BehaviorSubject.seeded([]);
  }

  final Database _db;
  final FriendDao _friendDao;
  final ChannelDao _channelDao;
  final ChannelMembershipDao _channelMembershipDao;
  late final BehaviorSubject<List<ChannelFullEntity>> _streamController;

  Stream<List<ChannelFullEntity>> get watchChannels {
    updateStream();
    return _streamController.stream;
  }

  /// WARNING : This method ignores any values in last message
  Future<void> insertAll(List<ChannelFullEntity> channelsData) async {
    final channels = channelsData.map((_) => _.channel).toList();
    final friends = channelsData
        .map((channelData) => channelData.channelUsers)
        .flattened
        .toList();
    final memberships = channelsData
        .map(
          (channelData) => channelData.channelUsers.map(
            (friend) => ChannelMembership(channelData.channel.id, friend.id),
          ),
        )
        .flattened
        .toList();

    await _friendDao.upsertAll(friends);
    await _channelDao.upsertAll(channels);
    await _channelMembershipDao.upsertAll(memberships);
    updateStream();
  }

  Future<void> updateStream() async {
    final results = await _db.rawQuery(
      '''
      SELECT
        ch.id AS channel_id,
        ch.name AS channel_name,
        ch.type AS channel_type,
        friend.id AS friend_id,
        friend.name AS friend_name,
        friend.username AS friend_username,
        friend.profile_pic_url AS friend_pic_url,
        last_message.id AS last_message_id,
        last_message.text AS last_message_text,
        last_message.image_url AS last_message_image_url,
        last_message.channel_id AS last_message_channel_id,
        last_message.sender_id AS last_message_sender_id,
        last_message.seen_by AS last_message_seen_by,
        last_message.timestamp AS last_message_timestamp,
        last_message.is_own_message AS last_message_is_own_message
      FROM 
      t_channels ch INNER JOIN t_channel_memberships ch_mem ON ch.id = ch_mem.channel_id
      INNER JOIN t_friends friend ON friend.id = ch_mem.friend_id
      LEFT JOIN (
        SELECT * FROM t_messages msg
        INNER JOIN (
          SELECT channel_id, MAX(timestamp) AS max_t FROM t_messages GROUP BY channel_id
        ) m ON m.channel_id = msg.channel_id AND m.max_t = msg.timestamp
      ) last_message ON last_message.channel_id = ch.id
      ''',
    );
    final channelsMap = groupBy(
      results,
      (result) => result['channel_id'],
    );
    final List<ChannelFullEntity> channels = [];
    channelsMap.forEach(
      (key, value) {
        if (value.isEmpty) return;
        final channel = ChannelEntity(
          id: value[0]['channel_id'] as int,
          name: value[0]['channel_name'] as String?,
          type: (value[0]['channel_type'] as int) == 0
              ? ChannelType.dm
              : ChannelType.group,
        );
        final List<FriendEntity> friends = [];
        for (final map in value) {
          friends.add(
            FriendEntity(
              id: map['friend_id'] as int,
              name: map['friend_name'] as String,
              username: map['friend_username'] as String,
              profilePicUrl: map['friend_pic_url'] as String?,
            ),
          );
        }
        MessageEntity? lastMessage;
        if (value[0]['last_message_id'] != null) {
          // then there is a last message.
          lastMessage = MessageEntity(
            id: value[0]['last_message_id'] as String,
            text: value[0]['last_message_text'] as String?,
            imageUrl: value[0]['last_message_image_url'] as String?,
            channelId: value[0]['last_message_channel_id'] as int,
            senderId: value[0]['last_message_sender_id'] as int,
            seenBy: (value[0]['last_message_seen_by'] as String)
                .split(',')
                .map((id) => int.tryParse(id))
                .toList()
                .mapNotNull(),
            timestamp: value[0]['last_message_timestamp'] as int,
            isOwnMessage: (value[0]['last_message_is_own_message'] as int) == 0
                ? false
                : true,
          );
        }
        channels.add(
          ChannelFullEntity(
            channel: channel,
            lastMessage: lastMessage,
            channelUsers: friends,
          ),
        );
      },
    );
    _streamController.add(channels);
  }
}
