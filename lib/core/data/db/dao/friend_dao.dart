import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:sqflite/sqflite.dart';

class FriendDao {
  FriendDao(Database db) : _db = db;

  static const tableName = 't_friends';

  final Database _db;

  Future<void> insert(FriendEntity friend) async {
    await _db.insert(
      tableName,
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> insertAll(List<FriendEntity> friends) async {
    final batch = _db.batch();
    for (final friend in friends) {
      batch.insert(
        tableName,
        friend.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    }
    await batch.commit();
  }

  Future<List<FriendEntity>> getAllFriends() async {
    final results = await _db.query(tableName);
    return results.map((map) => FriendEntity.fromMap(map)).toList();
  }

  Future<void> upsert(FriendEntity friend) async {
    await _db.insert(
      tableName,
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertAll(List<FriendEntity> friends) async {
    final batch = _db.batch();
    for (final friend in friends) {
      batch.insert(
        tableName,
        friend.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  // returns deleted count
  Future<int> deleteById(int friendId) async {
    return await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [friendId],
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
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        profile_pic_url TEXT
      )
      ''',
    );
  }
}
