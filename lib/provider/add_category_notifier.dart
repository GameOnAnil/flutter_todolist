import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class AddCategoryNotifier extends ChangeNotifier {
  String _title = "";
  String get title => _title;

  int _color = Colors.pink.value;
  int get color => _color;

  Future<void> setTitle(String data) async {
    _title = data;
    notifyListeners();
  }

  Future<void> setColor(int data) async {
    _color = data;
    notifyListeners();
  }

  Future<void> reset() async {
    _title = "";
    _color = Colors.pink.value;
  }
}
