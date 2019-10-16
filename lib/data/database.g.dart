// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final database = _$AppDatabase();
    database.database = await database.open(
      name ?? ':memory:',
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao _personDaoInstance;

  ReportDao _reportDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER, `firstName` TEXT, `lastName` TEXT, `address` TEXT, `birthdate` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Report` (`id` INTEGER, `reporterId` INTEGER, `codeName` TEXT, `breed` TEXT, `latitude` REAL, `longitude` REAL, `landmark` TEXT, `additionalInfo` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  UserDao get personDao {
    return _personDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  ReportDao get reportDao {
    return _reportDaoInstance ??= _$ReportDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthdate': item.birthdate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _userMapper = (Map<String, dynamic> row) => User();

  final InsertionAdapter<User> _userInsertionAdapter;

  @override
  Future<List<User>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM User', mapper: _userMapper);
  }

  @override
  Future<void> insert(User user) async {
    await _userInsertionAdapter.insert(user, sqflite.ConflictAlgorithm.abort);
  }
}

class _$ReportDao extends ReportDao {
  _$ReportDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _reportInsertionAdapter = InsertionAdapter(
            database,
            'Report',
            (Report item) => <String, dynamic>{
                  'id': item.id,
                  'reporterId': item.reporterId,
                  'codeName': item.codeName,
                  'breed': item.breed,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'landmark': item.landmark,
                  'additionalInfo': item.additionalInfo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _reportMapper = (Map<String, dynamic> row) => Report();

  final InsertionAdapter<Report> _reportInsertionAdapter;

  @override
  Future<List<Report>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM Report',
        mapper: _reportMapper);
  }

  @override
  Future<void> insert(Report report) async {
    await _reportInsertionAdapter.insert(
        report, sqflite.ConflictAlgorithm.abort);
  }
}
