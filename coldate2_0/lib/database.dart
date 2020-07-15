import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coldate2_0/memo.dart';

void InsertMetabo(int m) async{
  final database = openDatabase(
    join(await getDatabasesPath(), 'metaboric.db'),
    onCreate: (db, version){
      return db.execute(
        'CREATE TABLE memo(meta INTEGER)',
      );
    },
    version: 1
  );

  Future<void> insertMemo(Memo memo) async{
    final Database db = await database;
    await db.insert(
      'memo',
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Memo>> getMemos() async{
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memo');
    return List.generate(maps.length, (i) {
      return Memo(
        metab: maps[i]['meta']
      );
    });
  }

  var metaboresult = Memo(
    metab: m
  );
  await insertMemo(metaboresult);
  print(await getMemos());
}

Future<List<Memo>> getmetabos() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'metaboric.db'),
    onCreate: (db, version){
      return db.execute(
        'CREATE TABLE memo(meta INTEGER)',
      );
    },
    version: 1
  );

  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('memo');
  return List.generate(maps.length, (i){
    return Memo(
      metab: maps[i]['meta']
    );
  });
}