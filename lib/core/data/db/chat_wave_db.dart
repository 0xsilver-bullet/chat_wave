import 'package:chat_wave/core/data/db/dao/db_message_dao.dart';
import 'package:chat_wave/core/data/db/dao/friend_dao.dart';
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
        _initializeDAOs(db);
      },
    );
    _dmMessageDao = DmMessageDao(_database!);
    _friendDao = FriendDao(_database!);
    return _database!;
  }

  static const int version = 1;
  static Database? _database;
  static DmMessageDao? _dmMessageDao;
  static FriendDao? _friendDao;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // then we need to initialize the databse
    return await initialize();
  }

  DmMessageDao get dmMessageDao => _dmMessageDao!;

  FriendDao get friendDao => _friendDao!;

  Future<void> _initializeDAOs(Database db) async {
    await DmMessageDao.createTable(db);
    await FriendDao.createTable(db);
  }
}
