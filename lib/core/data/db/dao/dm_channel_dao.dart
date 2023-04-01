import 'dart:async';

import 'package:chat_wave/core/data/db/entity/dm_channel.dart';
import 'package:chat_wave/core/data/db/entity/dm_message.dart';
import 'package:sqflite/sqflite.dart';

class DmChannelDao {
  DmChannelDao(Database db) : _db = db {
    _streamController = StreamController<List<DmChannelEntity>>.broadcast();
  }

  static Future<void> createTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS $tableName(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        profile_pic_url TEXT NULL,
        last_message_id INTEGER REFERENCES t_dm_messages(id) ON DELETE SET NULL
      )
      ''',
    );
  }

  static const tableName = 't_dm_channels';

  final Database _db;
  Stream<List<DmChannelEntity>> get watchDmChannels => _streamController.stream;
  late final StreamController<List<DmChannelEntity>> _streamController;

  Future<void> insert(DmChannelEntity channel) async {
    await _db.insert(
      tableName,
      channel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    _updateStream();
  }

  Future<void> insertAll(List<DmChannelEntity> channels) async {
    final batch = _db.batch();
    for (final channel in channels) {
      batch.insert(
        tableName,
        channel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit();
    _updateStream();
  }

  Future<void> updateChannelLastMessage(
    int channelId,
    String messageId,
  ) async {
    await _db.update(
      tableName,
      {
        'last_message_id': messageId,
      },
      where: 'id = ?',
      whereArgs: [channelId],
    );
    _updateStream();
  }

  void refreshChannelsStream() {
    _updateStream();
  }

  Future<void> _updateStream() async {
    final maps = await _db.rawQuery(
      '''
SELECT 
    $tableName.id as channel_id,
    $tableName.name,
    $tableName.username,
    $tableName.profile_pic_url,
    t_dm_messages.id,
    t_dm_messages.text,
    t_dm_messages.sender_id,
    t_dm_messages.receiver_id,
    t_dm_messages.timestamp,
    t_dm_messages.is_own_message,
    t_dm_messages.seen
FROM $tableName
LEFT JOIN t_dm_messages
ON $tableName.last_message_id = t_dm_messages.id
ORDER BY t_dm_messages.timestamp DESC
      ''',
    );
    final List<DmChannelEntity> channels = [];
    for (final result in maps) {
      DmMessageEntity? lastDm;
      if (result['id'] != null) {
        // Then there is a last dm message in this channel
        lastDm = DmMessageEntity.fromMap(result);
      }
      final channel = DmChannelEntity.fromMap(result, lastDm);
      channels.add(channel);
    }
    _streamController.add(channels);
  }
}
