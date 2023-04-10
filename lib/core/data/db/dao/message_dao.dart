import 'dart:async';

import 'package:chat_wave/core/data/db/entity/message.dart';
import 'package:sqflite/sqflite.dart';

class MessageDao {
  MessageDao(Database db) : _db = db {
    _streamController = StreamController.broadcast();
  }

  static const tableName = 't_messages';

  final Database _db;
  late final StreamController<List<MessageEntity>> _streamController;
  int? _watchedChannelId;

  Stream<List<MessageEntity>> watchChannelMessages(int channelId) {
    _watchedChannelId = channelId;
    _updateStream();
    return _streamController.stream;
  }

  Future<void> insert(MessageEntity message) async {
    await _db.insert(
      tableName,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    _updateStream();
  }

  Future<void> insertAll(List<MessageEntity> messages) async {
    final batch = _db.batch();
    for (final message in messages) {
      batch.insert(
        tableName,
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    }
    await batch.commit();
    _updateStream();
  }

  Future<List<MessageEntity>> getChannelMessages(int channelId) async {
    final results = await _db.query(
      tableName,
      where: 'channel_id = ?',
      whereArgs: [channelId],
      orderBy: 'timestamp DESC',
    );
    return results.map((map) => MessageEntity.froMap(map)).toList();
  }

  Future<void> upsert(MessageEntity message) async {
    await _db.insert(
      tableName,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _updateStream();
  }

  Future<void> upsertAll(List<MessageEntity> messages) async {
    final batch = _db.batch();
    for (final message in messages) {
      batch.insert(
        tableName,
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
    _updateStream();
  }

  Future<void> replace(String provisionalId, MessageEntity newMessage) async {
    await _db.transaction(
      (txn) async {
        await txn
            .delete(tableName, where: 'id = ?', whereArgs: [provisionalId]);
        await txn.insert(
          tableName,
          newMessage.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      },
    );
  }

  Future<int> deleteById(String id) async {
    final deleteCount = _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    _updateStream();
    return deleteCount;
  }

  Future<void> clear() async {
    await _db.delete(tableName);
    _updateStream();
  }

  Future<void> _updateStream() async {
    final watchedChannelId = _watchedChannelId;
    if (watchedChannelId == null) return;
    final messages = await getChannelMessages(watchedChannelId);
    _streamController.add(messages);
  }

  static Future<void> createTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE $tableName(
        id VARCHAR(24) PRIMARY KEY NOT NULL,
        text TEXT,
        image_url VARCHAR(128),
        channel_id INT NOT NULL REFERENCES t_channels(id) ON DELETE CASCADE,
        sender_id INT NOT NULL REFERENCES t_friends(id) ON DELETE CASCADE,
        seen_by VARCHAR(256) NOT NULL,
        timestamp INT NOT NULL,
        is_own_message INT NOT NULL
      )
      ''',
    );
  }
}
