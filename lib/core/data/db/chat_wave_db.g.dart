// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_wave_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorChatWaveDb {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ChatWaveDbBuilder databaseBuilder(String name) =>
      _$ChatWaveDbBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ChatWaveDbBuilder inMemoryDatabaseBuilder() =>
      _$ChatWaveDbBuilder(null);
}

class _$ChatWaveDbBuilder {
  _$ChatWaveDbBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$ChatWaveDbBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$ChatWaveDbBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<ChatWaveDb> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ChatWaveDb();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ChatWaveDb extends ChatWaveDb {
  _$ChatWaveDb([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FriendDao? _friendDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `friends` (`name` TEXT NOT NULL, `username` TEXT NOT NULL, `profile_pic_url` TEXT, `id` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FriendDao get friendDao {
    return _friendDaoInstance ??= _$FriendDao(database, changeListener);
  }
}

class _$FriendDao extends FriendDao {
  _$FriendDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _friendInsertionAdapter = InsertionAdapter(
            database,
            'friends',
            (Friend item) => <String, Object?>{
                  'name': item.name,
                  'username': item.username,
                  'profile_pic_url': item.profilePicUrl,
                  'id': item.id
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Friend> _friendInsertionAdapter;

  @override
  Stream<List<Friend>> findAllFriends() {
    return _queryAdapter.queryListStream('SELECT * FROM Friend',
        mapper: (Map<String, Object?> row) => Friend(
            name: row['name'] as String,
            username: row['username'] as String,
            profilePicUrl: row['profile_pic_url'] as String?,
            id: row['id'] as int),
        queryableName: 'Friend',
        isView: false);
  }

  @override
  Future<void> insertFriend(Friend friend) async {
    await _friendInsertionAdapter.insert(friend, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAllFriends(List<Friend> friends) async {
    await _friendInsertionAdapter.insertList(friends, OnConflictStrategy.abort);
  }
}
