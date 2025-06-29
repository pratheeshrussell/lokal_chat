import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokal_chat/app/constants/paths.dart';
import 'package:lokal_chat/app/migrations/migrations.dart';
import 'package:lokal_chat/app/types/db.types.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DbHandler extends GetxService {
  late Database db;

  RxList<ChatEntity> chatList = RxList<ChatEntity>([]);

  @override
  void onInit() async {
    super.onInit();
  }

   Future<DbHandler> init() async {
    await initializeDB();
    _setChatListToObs();
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

  Future<int> insertModel(ModelEntity model) async {
    int id = await db.insert('models', model.toMap(), 
    conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<List<ChatEntity>> getChatList() async {
    List<Map<String, Object?>> chatsRaw = await db.query(
      'chat', orderBy: 'lastUpdated DESC');
    List<ChatEntity> chats = chatsRaw.map(
      (chat){
        return ChatEntity.fromMap(chat);
      }).toList();

    return chats;
  }

  void _setChatListToObs(){
    debugPrint('CHAT MESSAGE LIST: FETCHING VALUES');
    getChatList().then((chats){
      chatList.value = [...chats];
      chatList.refresh();
    });
  }

  Future<int> insertChat(ChatEntity chat) async {
    int id = await db.insert('chat', chat.toMap(), 
    conflictAlgorithm: ConflictAlgorithm.replace);
    _setChatListToObs();
    return id;
  }

  Future<int> updateChatTime(int id) async {
    int retid = await db.update(
      'chat', {
        'lastUpdated': (DateTime.now()).millisecondsSinceEpoch
      }, 
    where: 'id = ?', whereArgs: [id],
    conflictAlgorithm: ConflictAlgorithm.replace);
    _setChatListToObs();
    return retid;
  }

  Future<int> updateChatTitle(int id, String title) async {
    int retid = await db.update(
      'chat', {
        'title': title
      }, 
    where: 'id = ?', whereArgs: [id],
    conflictAlgorithm: ConflictAlgorithm.replace);
    _setChatListToObs();
    return retid;
  }

  Future<void> deleteChat(int id) async {
    await db.delete(
    'chatmessages', where: 'chatid = ?', whereArgs: [id]);
    await db.delete(
    'chat', where: 'id = ?', whereArgs: [id]);
    _setChatListToObs();
    
  }

  Future<int> insertChatMessage(ChatMessageEntity chatmessage) async {
    int id = await db.insert('chatmessages', chatmessage.toMap(), 
    conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }


}