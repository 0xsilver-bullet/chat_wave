import 'dart:async';

import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:sqflite/sqflite.dart';

class FriendDao {
  FriendDao(Database db) : _db = db {
    _streamController = StreamController<List<FriendEntity>>.broadcast();
  }

  static Future<void> createTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS $tableName(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        profile_pic_url TEXT NULL
      )
      ''',
    );
  }

  static const tableName = "t_friends";

  final Database _db;
  late final StreamController<List<FriendEntity>> _streamController;
  Stream<List<FriendEntity>> get watchFriends => _streamController.stream;

  Future<void> insertFriend(FriendEntity friend) async {
    await _db.insert(
      tableName,
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _updateStream();
  }

  Future<void> insertAllFriends(List<FriendEntity> friends) async {
    final batch = _db.batch();
    for (final friend in friends) {
      batch.insert(
        tableName,
        friend.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
    _updateStream();
  }

  Future<void> _updateStream() async {
    final maps = await _db.query(tableName);
    final friends = maps
        .map(
          (map) => FriendEntity.fromMap(map),
        )
        .toList();
    _streamController.add(friends);
  }
}
