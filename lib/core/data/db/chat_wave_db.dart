import 'package:chat_wave/core/data/db/dao/channel_dao.dart';
import 'package:chat_wave/core/data/db/dao/channel_full_dao.dart';
import 'package:chat_wave/core/data/db/dao/channel_membership_dao.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
import 'package:chat_wave/core/data/db/dao/message_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatWaveDb {
  Future<Database> initialize() async {
    if (_database != null) {
      return _database!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_wave_database.db');

    _database = await openDatabase(
      path,
      version: version,
      onCreate: (db, version) {
        _createTables(db);
      },
    );
    _friendDao = FriendDao(_database!);
    _channelDao = ChannelDao(_database!);
    _messageDao = MessageDao(_database!);
    _channelMembershipDao = ChannelMembershipDao(_database!);
    _channelFullDao = ChannelFullDao(
      db: _database!,
      channelDao: _channelDao!,
      friendDao: _friendDao!,
      channelMembershipDao: _channelMembershipDao!,
      messageDao: _messageDao!,
    );
    return _database!;
  }

  static const int version = 1;
  static Database? _database;
  static FriendDao? _friendDao;
  static ChannelDao? _channelDao;
  static MessageDao? _messageDao;
  static ChannelMembershipDao? _channelMembershipDao;
  static ChannelFullDao? _channelFullDao;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // then we need to initialize the databse
    return await initialize();
  }

  FriendDao get friendDao => _friendDao!;
  ChannelDao get channelDao => _channelDao!;
  MessageDao get messageDao => _messageDao!;
  ChannelMembershipDao get channelMembershipDao => _channelMembershipDao!;
  ChannelFullDao get channelFullDao => _channelFullDao!;

  Future<void> _createTables(Database db) async {
    await FriendDao.createTable(db);
    await ChannelDao.createTable(db);
    await MessageDao.createTable(db);
    await ChannelMembershipDao.createTable(db);
  }
}
