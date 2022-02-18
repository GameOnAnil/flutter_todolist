import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_category_page.dart';
import 'package:todo_app/screens/add_items_page.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/todo_page.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const HomePage());
      case "/todos":
        return MaterialPageRoute(
            builder: (_) => TodoPage(categoryId: args! as int));
      case "/addCategory":
        return MaterialPageRoute(builder: (_) => AddCategoryPage());
      case "/addItemPage":
        return MaterialPageRoute(
            builder: (_) => AddItemsPage(
                  categoryId: args! as int,
                ));
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
