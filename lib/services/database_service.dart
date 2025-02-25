import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../features/users/data/model/user_model.dart';

class DatabaseService {
  static Database? _db;
  DatabaseService._constructor();
  static final DatabaseService instance = DatabaseService._constructor();

  final String _userTable = 'user';
  final String _idColumn = 'id';
  final String _nameColumn = 'name';
  final String _ageColumn = 'age';
  final String _genderColumn = 'gender';
  final String _mailColumn = 'mail';

  int _currentUserId = 0;
  int generateUserId() {
    _currentUserId += 1;
    return _currentUserId;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;

    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "test_db.db");

    try {
      _db =
          await openDatabase(databasePath, version: 1, onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_userTable (
            $_idColumn INTEGER PRIMARY KEY,
            $_nameColumn TEXT,
            $_ageColumn TEXT,
            $_genderColumn TEXT,
            $_mailColumn TEXT
          )
        ''');
      });
    } catch (e) {
      print("Database initialization error: $e");
    }

    return _db!;
  }

  Future<void> addUser(
      String name, String age, String gender, String mail) async {
    final db = await database;
    await db.insert(
      _userTable,
      {
        _nameColumn: name,
        _ageColumn: age,
        _genderColumn: gender,
        _mailColumn: mail,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addUserFromRemote(
      String name, String age, String gender, String mail) async {
    final db = await database;
    await db.delete(_userTable);
    await db.insert(
      _userTable,
      {
        _nameColumn: name,
        _ageColumn: age,
        _genderColumn: gender,
        _mailColumn: mail,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(
      String id, String name, String age, String gender, String mail) async {
    final db = await database;
    await db.update(
      _userTable,
      {
        _nameColumn: name,
        _ageColumn: age,
        _genderColumn: gender,
        _mailColumn: mail
      },
      where: '$_idColumn= ?',
      whereArgs: [int.parse(id)],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db
        .delete(_userTable, where: '$_idColumn = ?', whereArgs: [id]);
  }

  Future<List<User>> getUser() async {
    final db = await database;
    final data = await db.query(_userTable);
    return data
        .map((e) => User(
              id: e[_idColumn] as int,
              name: e[_nameColumn] as String,
              age: e[_ageColumn] as String,
              gender: e[_genderColumn] as String,
              email: e[_mailColumn] as String,
            ))
        .toList();
  }
}
