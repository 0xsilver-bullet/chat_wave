import 'dart:async';

import 'package:chat_wave/core/data/db/dao/channel_dao.dart';
import 'package:chat_wave/core/data/db/dao/channel_membership_dao.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/entity/channel_membership.dart';
import 'package:collection/collection.dart';

import 'package:chat_wave/core/data/db/entity/channel_full.dart';
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
    _streamController = StreamController();
  }

  final Database _db;
  final FriendDao _friendDao;
  final ChannelDao _channelDao;
  final ChannelMembershipDao _channelMembershipDao;
  late final StreamController<List<ChannelFullEntity>> _streamController;

  Stream<List<ChannelFullEntity>> get watchChannels => _streamController.stream;

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

    await _friendDao.insertAll(friends);
    await _channelDao.insertAll(channels);
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
        last_message.*,
        friend.id AS friend_id,
        friend.name AS friend_name,
        friend.username AS friend_username,
        friend.profile_pic_url AS friend_profile_pic_url
      FROM t_channels ch
      LEFT JOIN (
        SELECT
          message.id AS message_id,
          message.text AS message_text,
          message.image_url AS message_image_url,
          message.channel_id AS message_channel_id,
          message.sender_id AS message_sender_id,
          message.seen_by AS message_seen_by,
          message.timestamp AS message_timestamp
        FROM t_messages message
        INNER JOIN (
          SELECT channel_id, MAX(timestamp) AS last_message_time
          FROM t_messages
          GROUP BY channel_id
        ) last_msg ON message.channel_id = last_msg.channel_id AND message.timestamp = last_msg.last_message_time
      ) last_message ON last_message.channel_id = ch.id
      LEFT JOIN t_channel_memberships ch_mem ON ch.id = ch_mem.channel_id
      LEFT JOIN t_friends friend ON ch_mem.friend_id = friend.id
      ORDER BY last_message.message_timestamp DESC
      ''',
    );
    final channelsMap = groupBy(
      results,
      (result) => result['channel_id'],
    );
    print(channelsMap);
  }
}
