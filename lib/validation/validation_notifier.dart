import 'package:flutter/material.dart';
import 'package:todo_app/validation/validationitem.dart';

class ValidationNotifier extends ChangeNotifier {
  ValidationItem _title = ValidationItem(null, null);
  ValidationItem _description = ValidationItem(null, null);

  ValidationItem get title => _title;
  ValidationItem get desc => _description;

  void changeTitle(String value) {
    if (value.length > 0) {
      _title = ValidationItem(value, null);
    } else {
      _title = ValidationItem(null, "Title cannot be empty");
    }
    notifyListeners();
  }

  void changeDescription(String value) {
    if (value.isNotEmpty) {
      _description = ValidationItem(value, null);
    } else {
      _description = ValidationItem(null, "Description cannot be empty");
    }
    notifyListeners();
  }
}
