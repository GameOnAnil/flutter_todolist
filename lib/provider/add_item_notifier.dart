import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:intl/intl.dart';

class AddItemNotifier extends ChangeNotifier {
  String _title = "";
  String get title => _title;

  String _description = "";
  String get description => _description;

  String? _date;
  String? get date => _date;

  String _dateError = "";
  String get dateError => _dateError;

  String? _time;
  String? get time => _time;

  String _timeError = "";
  String get timeError => _timeError;

  AddItemNotifier();

  Future<void> setDate(DateTime newDate) async {
    _date = DateFormat("yyyy-MM-dd").format(newDate);
    _dateError = "";
    notifyListeners();
  }

  Future<void> setTime(String newTime) async {
    _time = newTime;
    _timeError = "";
    notifyListeners();
  }

  Future<bool> validate() async {
    _timeError = _time == null ? "Due Time Required" : "";
    _dateError = _date == null ? "Due Date Required" : "";

    if (_dateError.isNotEmpty || _timeError.isNotEmpty) {
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  Future<void> reset() async {
    _title = "";
    _description = "";
    _date = null;
    _time = null;
    _dateError = "";
    _timeError = "";
  }

  setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  Future<ToDo> getToDo(int categoryId) async {
    return ToDo(
        id: null,
        title: _title,
        description: _description,
        isCompleted: 0,
        date: _date!,
        time: _time!,
        categoryId: categoryId);
  }

  void clearTime() {
    _time = "";
    _timeError = "";
    notifyListeners();
  }
}
