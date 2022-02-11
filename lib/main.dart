import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_items_page.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/addItemPage": (context) => AddItemsPage(),
      },
    );
  }
}
