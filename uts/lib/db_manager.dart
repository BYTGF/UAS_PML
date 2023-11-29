import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final tableStorages = 'storages';
  static final tableUsers = 'users';
  static final tableItems = 'items';
  static final tableHistories = 'history';

  static final columnId = '_id';

  static final columnName = 'name';
  static final columnUsername = 'username';
  static final columnPassword = 'pass';
  
  static final columnStorage = "storage_id";
  static final columnQty = 'qty';
  static final columnUnit = 'unit';

  static final columnItem = 'item_id';
  static final columnStatus = 'status';
  static final columnDate = 'date';
  

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database?> get database1 async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''
          CREATE TABLE $tableStorages (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL 
          )
          ''');
    await db.execute(
        '''
          CREATE TABLE $tableUsers (
            $columnId INTEGER PRIMARY KEY,
            $columnUsername TEXT NOT NULL,
            $columnDate TEXT NOT NULL
          )
          ''');
    await db.execute(
        '''
          CREATE TABLE $tableItems (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnStorage INTEGER NOT NULL,
            $columnQty INTEGER NOT NULL,
            FOREIGN KEY ($columnStorage) REFERENCES $tableStorages($columnId)
            ON DELETE CASCADE
          )
          ''');
    await db.execute(
        '''
          CREATE TABLE $tableHistories (
            $columnId INTEGER PRIMARY KEY,
            $columnItem INTEGER NOT NULL,
            $columnStatus TEXT NOT NULL,
            $columnQty INTEGER NOT NULL, 
            $columnDate TIMESTAMP DEFAULT (datetime('now')),
            FOREIGN KEY ($columnItem) REFERENCES $tableItems($columnId)
            ON DELETE CASCADE
          )
          ''');
    await db.execute('''
      CREATE TRIGGER update_item_quantity
      AFTER INSERT ON $tableHistories
      FOR EACH ROW
      BEGIN
        UPDATE $tableItems
        SET $columnQty = $columnQty + NEW.$columnQty
        WHERE $columnId = NEW.$columnItem;
      END;
    ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertStorage(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(tableStorages, row);
  }

  Future<int> insertItem(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(tableItems, row);
  }

  Future<int> insertHistory(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(tableHistories, row);
  }

  Future<int> insertUsers(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db.insert(tableUsers, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRowsStorage() async {
    Database db = await instance.database;
    return await db.query(tableStorages);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsItem() async {
    Database db = await instance.database;
    String query = '''
      SELECT
        $tableItems.$columnId AS itemId,
        $tableItems.$columnName AS itemName,
        $tableStorages.$columnName AS storageName,
        $tableItems.$columnQty AS itemQty
      FROM $tableItems
      INNER JOIN $tableStorages ON $tableItems.$columnStorage = $tableStorages.$columnId
    ''';

    try {
      List<Map<String, dynamic>> results = await db.rawQuery(query);
      return results;
    } catch (e) {
      print('Error querying database: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryAllRowsHistory() async {
    Database db = await instance.database;
    String query = '''
      SELECT
        $tableHistories.$columnId AS historyId,
        $tableItems.$columnName AS itemName,
        $tableHistories.$columnStatus AS historyStatus,
        $tableHistories.$columnQty AS historyQty,
        $tableHistories.$columnDate AS historyDate
      FROM $tableHistories
      INNER JOIN $tableItems ON $tableHistories.$columnItem = $tableItems.$columnId
    ''';

    // Execute the query and return the results as a list of maps.
    final List<Map<String, dynamic>> results = await db.rawQuery(query);

    return results;
  }

  Future<List<Map<String, dynamic>>> queryAllRowsUser() async {
    Database db = await instance.database;
    return await db.query(tableUsers);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $tableStorages')) ??
        0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateStorage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(tableStorages, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateItem(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(tableItems, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateUsers(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(tableUsers, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStorage(int id) async {
    Database db = await instance.database;
    return await db.delete(tableStorages, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(int id) async {
    Database db = await instance.database;
    return await db.delete(tableItems, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(tableUsers, where: '$columnId = ?', whereArgs: [id]);
  }
}
