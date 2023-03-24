import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

import 'dao/friend_dao.dart';
import 'entity/friend.dart';

part 'chat_wave_db.g.dart';

@Database(version: 1, entities: [Friend])
abstract class ChatWaveDb extends FloorDatabase {
  FriendDao get friendDao;

  static Future<ChatWaveDb> initializeDb() async {
    return await $FloorChatWaveDb.databaseBuilder('chat_wave.db').build();
  }
}
