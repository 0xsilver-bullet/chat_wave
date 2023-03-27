import 'package:chat_wave/core/data/db/dao/dm_message_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

import 'dao/friend_dao.dart';
import 'entity/dm_message.dart';
import 'entity/friend.dart';

part 'chat_wave_db.g.dart';

@Database(
  version: 1,
  entities: [
    Friend,
    DmMessageEntity,
  ],
)
abstract class ChatWaveDb extends FloorDatabase {
  FriendDao get friendDao;
  DmMessageDao get dmMessageDao;

  static Future<ChatWaveDb> initializeDb() async {
    return await $FloorChatWaveDb.databaseBuilder('chat_wave.db').build();
  }
}
