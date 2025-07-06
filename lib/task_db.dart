import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class TaskDb {
  static Database? _database;


  Future<Database?> get database async {
    if (_database == null) {
      return _database = await _initDb();
    } else {
      return _database;
    }
  }

  Future<Database> _initDb() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'task.db');
    if (kDebugMode) {
      print('Database path: $path');
    }
    Database database = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async {
        if (kDebugMode) print('Configuring DB');
        await db.execute('PRAGMA foreign_keys = ON'); // Example
      },

      onOpen: (db)async {
        // tasks=await getDb();
        if (kDebugMode) print('DB Opened');
      },
    );
    return database;
  }
  _onCreate(Database database,int version)async {
    if (kDebugMode) {
      print('Database created=============================With version $version ...... ');
    }
    await database
        .execute('''
  CREATE TABLE tasks(task_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  title TEXT, 
  time TEXT, 
  date TEXT, 
  status TEXT
  )
  ''')
        .then((value) {
      if (kDebugMode) {
        print('table created===================,');
      }
    })
        .catchError((error) {
      if (kDebugMode) {
        print('Error when creating table${error.toString()}');
      }

    }
    );

  }

  Future<void> insertToTask(
      String title,
      String time,
      String date,
      ) async {
    try {
      final Database? db = await database;
      if (db == null) {
        if (kDebugMode) {
          print('Error: Database instance is null .Cannot insert task.');
        }
        return;
      }
      await db.transaction((txn) async {
        try {
          int id = await txn.rawInsert(
            '''
      INSERT INTO tasks(title, time, date, status) VALUES (?,?,?,?)
      ''',
            [title, time, date, 'new'],
          );
          if (kDebugMode) {
            print('Insert successfully, ID:$id');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error when Insert to table ${e.toString()}');
          }
          rethrow;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error obtaining database or during transaction :${e.toString()}');
      }
      rethrow;
    }
  }

  Future<void> closeDb()async{
    final db =_database;
    if(db!=null &&db.isOpen){
      await db.close();
      _database=null;
      if(kDebugMode){
        print('Database closed. ');
      }
    }
  }

  Future<List<Map>> getDb()async{
    final Database? db=await database;
    if (db == null) {
      if (kDebugMode) {
        print('Error: Database instance is null .Cannot insert task.');
      }
    }
    return await db!.rawQuery('SELECT * FROM tasks');

  }

}
