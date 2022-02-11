import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/provider/db_notifier.dart';

class AddItemsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Items"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(dbStateProvider.notifier).insertToDo(ToDo(
                id: null,
                title: "First",
                description: "description",
                isCompleted: 0));
            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ),
    );
  }
}
