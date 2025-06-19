import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/paths.dart';
import 'package:lokal_chat/app/migrations/migrations.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DbHandler extends GetxService {
  late Database db;

  @override
  void onInit() async {
    super.onInit();
  }

   Future<DbHandler> init() async {
    await initializeDB();
    return this;
  }

  Future<void> initializeDB() async {
    String databasesPath = await AppPaths.dbPath;
    debugPrint(databasesPath);
    String path = p.join(databasesPath, AppMigrations.dbName);
    db = await openDatabase(path, version: AppMigrations.dbVersion, 
      onCreate: (db, version) async {
      for(String migration in AppMigrations.migrations){
        await db.execute(migration);
      }
    });
  }


}