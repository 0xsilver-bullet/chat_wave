import 'package:chat_wave/core/data/db/entity/channel.dart';
import 'package:sqflite/sqflite.dart';

class ChannelDao {
  ChannelDao(Database db) : _db = db;

  static const tableName = 't_channels';

  final Database _db;

  Future<void> insert(ChannelEntity channel) async {
    await _db.insert(
      tableName,
      channel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> insertAll(List<ChannelEntity> channels) async {
    final batch = _db.batch();
    for (final channel in channels) {
      batch.insert(
        tableName,
        channel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    }
    await batch.commit();
  }

  Future<void> upsert(ChannelEntity channel) async {
    await _db.insert(
      tableName,
      channel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertAll(List<ChannelEntity> channels) async {
    final batch = _db.batch();
    for (final channel in channels) {
      batch.insert(
        tableName,
        channel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit();
  }

  Future<int> deleteById(int channelId) async {
    return await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [channelId],
    );
  }

  Future<int> clear() async {
    return await _db.delete(tableName);
  }

  static Future<void> createTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE $tableName(
        id INT PRIMARY KEY NOT NULL,
        name TEXT,
        type INT NOT NULL
      )
      ''',
    );
  }
}
