import 'dart:async';

import 'package:chat_wave/core/data/db/dao/dm_channel_dao.dart';
import 'package:chat_wave/core/data/db/entity/dm_message.dart';
import 'package:sqflite/sqflite.dart';

class DmMessageDao {
  DmMessageDao(
    Database db,
    DmChannelDao dmChannelDao,
  )   : _db = db,
        _dmChannelDao = dmChannelDao {
    _streamController = StreamController<List<DmMessageEntity>>.broadcast();
  }

  static Future<void> createTable(Database db) async {
    await db.execute(
      '''
  CREATE TABLE IF NOT EXISTS $tableName (
    id TEXT PRIMARY KEY,
    text TEXT NULL,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    timestamp INT NOT NULL,
    is_own_message BOOLEAN NOT NULL CHECK (is_own_message IN (0,1)),
    seen BOOLEAN NOT NULL CHECK (seen IN (0,1))
      )
  ''',
    );
  }

  static const tableName = 't_dm_messages';

  final Database _db;
  final DmChannelDao _dmChannelDao;
  int? _watchedFriendId;
  late final StreamController<List<DmMessageEntity>> _streamController;

  Future<void> insert(DmMessageEntity message) async {
    await _db.insert(
      tableName,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    _updateStream();
    _dmChannelDao.updateChannelLastMessage(message.senderId, message.id);
  }

  Future<void> insertAll(List<DmMessageEntity> messages) async {
    final batch = _db.batch();
    for (final message in messages) {
      batch.insert(
        tableName,
        message.toMap(),
      );
    }
    await batch.commit();
    _updateStream();
    // update channels last message
    for (final message in messages) {
      _dmChannelDao.updateChannelLastMessage(message.senderId, message.id);
    }
  }

  // this method will support only one channel at a time.
  // this means that if you called it with a channel id and called it another time
  // with diffrent id then all listeners using this stream will receive updates for
  // that last channelId this method is called with.
  Stream<List<DmMessageEntity>> watchDmChannel(int friendId) {
    _watchedFriendId = friendId;
    _updateStream();
    return _streamController.stream;
  }

  Future<int> deleteById(String id) async {
    final deletedCount = await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    _updateStream();
    _dmChannelDao.refreshChannelsStream();
    return deletedCount;
  }

  Future<void> replace(String id, DmMessageEntity newMessage) async {
    await _db.transaction(
      (txn) async {
        final deletedCout = await txn.delete(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        );
        if (deletedCout != 1) throw Exception('Nothing to replace');
        await txn.insert(tableName, newMessage.toMap());
      },
    );
    _updateStream();
    _dmChannelDao.updateChannelLastMessage(
      newMessage.receiverId,
      newMessage.id,
    );
  }

  Future<void> _updateStream() async {
    if (_watchedFriendId == null) return;
    final maps = await _db.query(
      tableName,
      where: 'sender_id = ? OR receiver_id = ?',
      whereArgs: [_watchedFriendId, _watchedFriendId],
      orderBy: 'timestamp DESC',
    );
    final dms = maps
        .map(
          (map) => DmMessageEntity.fromMap(map),
        )
        .toList();
    _streamController.add(dms);
  }
}
