import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/model/todo.dart';

class DbHelper {
  final String _toDoTableName = 'todo';

  DbHelper._provideConstructor();
  static final DbHelper instance = DbHelper._provideConstructor();

  static Database? _database;
  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todo.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_toDoTableName(id INTEGER PRIMARY KEY, title TEXT, description Text,is_completed INTEGER)');
  }

  Future<List<ToDo>> getTodos() async {
    Database db = await instance.database;
    var todos = await db.query(_toDoTableName, orderBy: 'id');
    List<ToDo> todolist =
        todos.isNotEmpty ? todos.map((e) => ToDo.fromMap(e)).toList() : [];
    return todolist;
  }

  Future<void> insertTodo(ToDo toDo) async {
    try {
      Database db = await instance.database;
      db.insert("todo", toDo.toMap());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      Database db = await instance.database;
      await db.delete(_toDoTableName, where: "id=?", whereArgs: [id]);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateToDo(ToDo todo) async {
    try {
      Database db = await instance.database;
      await db.update(_toDoTableName, todo.toMap(),
          where: "id=?", whereArgs: [todo.id]);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
