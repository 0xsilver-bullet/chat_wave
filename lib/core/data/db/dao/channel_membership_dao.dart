import 'package:chat_wave/core/data/db/entity/channel_membership.dart';
import 'package:sqflite/sqflite.dart';

class ChannelMembershipDao {
  ChannelMembershipDao(Database db) : _db = db;

  static const tableName = 't_channel_memberships';

  final Database _db;

  Future<void> upsert(ChannelMembership membership) async {
    await _db.insert(
      tableName,
      membership.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> upsertAll(List<ChannelMembership> memberships) async {
    final batch = _db.batch();
    for (final membership in memberships) {
      batch.insert(
        tableName,
        membership.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit();
  }

  Future<int> delete(ChannelMembership membership) async {
    final deleteCount = await _db.delete(
      tableName,
      where: 'channel_id = ? AND friend_id = ?',
      whereArgs: [membership.channelId, membership.friendId],
    );
    return deleteCount;
  }

  static Future<void> createTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE $tableName(
        channel_id INT NOT NULL REFERENCES t_channels(id) ON DELETE CASCADE,
        friend_id INT NOT NULL REFERENCES t_friends(id) ON DELETE CASCADE,
        PRIMARY KEY (channel_id , friend_id)
      )
      ''',
    );
  }
}
