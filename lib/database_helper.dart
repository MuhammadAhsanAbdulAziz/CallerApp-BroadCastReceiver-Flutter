import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'my_data_mode.dart';

class DatabaseHelper {
  static const String tableName = 'my_table';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnDate = 'date';
  static const String columnTime = 'time';
  static const String columnState = 'state';

  late Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'my_database'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$columnName TEXT, $columnDate TEXT, $columnTime TEXT, $columnState TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<List<MyDataModel>> getAllData() async {
    _database = await initDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    final reversedMaps = List<Map<String, dynamic>>.from(maps.reversed);
    return List.generate(reversedMaps.length, (i) {
      return MyDataModel(
        id: reversedMaps[i]['id'],
        name: reversedMaps[i]['name'],
        date: reversedMaps[i]['date'],
        time: reversedMaps[i]['time'],
        state: reversedMaps[i]['state'],
      );
    });
  }

  Future<MyDataModel> getSingleData() async {
    _database = await initDatabase();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    final reversedMaps = List<Map<String, dynamic>>.from(maps.reversed);

    return MyDataModel(
      id: reversedMaps[0]['id'],
      name: reversedMaps[0]['name'],
      date: reversedMaps[0]['date'],
      time: reversedMaps[0]['time'],
      state: reversedMaps[0]['state'],
    );
  }
}
