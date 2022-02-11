import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/db_helper.dart';
import 'package:todo_app/model/todo.dart';

final dbStateProvider =
    StateNotifierProvider<DbNotifier, AsyncValue<List<ToDo>>>((ref) {
  return DbNotifier(const AsyncValue.loading());
});

class DbNotifier extends StateNotifier<AsyncValue<List<ToDo>>> {
  DbNotifier(AsyncValue<List<ToDo>> state) : super(state) {
    _fetchToDo();
  }

  Future<void> _fetchToDo() async {
    try {
      List<ToDo> todos = await DbHelper.instance.getTodos();
      state = AsyncValue.data(todos);
    } on Exception catch (e) {
      debugPrint("Fetch Error:$e");
    }
  }

  Future<void> insertToDo(ToDo toDo) async {
    await DbHelper.instance.insertTodo(toDo);
    state = state.whenData((value) => [...value, toDo]);
  }

  Future<void> deleteToDo(int id) async {
    await DbHelper.instance.deleteTodo(id);
    state = state.whenData(
      (todolist) => todolist.where((todo) => todo.id != id).toList(),
    );
  }

  Future<void> updateTodo(ToDo toDo) async {
    await DbHelper.instance.updateToDo(toDo);
    _fetchToDo();
  }
}
