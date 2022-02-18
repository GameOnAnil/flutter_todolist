import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/db_helper.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/todo.dart';

final categoryProvider =
    StateNotifierProvider<DbCategoryNotifier, AsyncValue<List<Category>>>(
        (ref) {
  return DbCategoryNotifier(const AsyncValue.loading());
});

class DbCategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  DbCategoryNotifier(AsyncValue<List<Category>> state) : super(state) {
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    try {
      List<Category> todos = await DbHelper.instance.getCategories();
      state = AsyncValue.data(todos);
    } on Exception catch (e) {
      debugPrint("Fetch Error:$e");
    }
  }

  Future<void> insertCategory(Category category) async {
    await DbHelper.instance.insertCategory(category);
    state = state.whenData((value) => [...value, category]);
  }

  Future<void> deleteCategory(int id) async {
    await DbHelper.instance.deleteCategory(id);
    state = state.whenData(
      (category) => category.where((cat) => cat.id != id).toList(),
    );
  }

  Future<void> updateCategory(Category category) async {
    await DbHelper.instance.updateCategory(category);
    _fetchCategory();
  }
}
