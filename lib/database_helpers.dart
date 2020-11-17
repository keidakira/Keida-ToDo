import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableName = 'task';
final String columnId = '_id';
final String columnTask = 'task';
final String columnStatus = 'status';

// data model class
class Task {

  int id;
  String task;
  int status;

  Task();

  // convenience constructor to create a Word object
  Task.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    task = map[columnTask];
    status = map[columnStatus];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTask: task,
      columnStatus: status
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "keidabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableName (
                $columnId INTEGER PRIMARY KEY,
                $columnTask TEXT NOT NULL,
                $columnStatus INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Task word) async {
    Database db = await database;
    int id = await db.insert(tableName, word.toMap());
    return id;
  }

  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(tableName, where: "_id = ?", whereArgs: [id]);
  }

  Future<void> updateStatus(Map newData) async {
    Database db = await database;
    var res = await db.update(tableName, newData,
        where: "_id = ?", whereArgs: [newData['_id']]);
    print(res);
  }

  Future<List<Map>> getAllTasks() async {
    Database db = await database;
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnTask, columnStatus]);
    if (maps.length > 0) {
      return maps;
    }
    return null;
  }

  Future<int> getLastId() async {
    Database db = await database;
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnTask, columnStatus]);
    return maps.last['_id'];
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}