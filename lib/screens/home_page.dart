import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/provider/db_notifier.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addItemPage");
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Text(
                "What's up,Anil!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Expanded(child: const ListPart()),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        iconSize: 25.0,
        color: Colors.black87,
        onPressed: () {},
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          iconSize: 25.0,
          color: Colors.black87,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
          ),
          iconSize: 25.0,
          color: Colors.black87,
        ),
      ],
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }
}

class ListPart extends StatelessWidget {
  const ListPart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(dbStateProvider).when(
              error: (e, s) => const Center(child: Text("ERROR")),
              loading: () => const CircularProgressIndicator(),
              data: (data) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    ToDo currentTodo = data[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(
                        currentTodo.title,
                        style: TextStyle(
                            decoration: currentTodo.isCompleted == 1
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      subtitle: Text(
                        currentTodo.description,
                      ),
                      leading: Checkbox(
                        onChanged: (value) {
                          if (value != null) {
                            if (value == true) {
                              ref.read(dbStateProvider.notifier).updateTodo(
                                  currentTodo.copyWith(isCompleted: 1));
                            } else {
                              ref.read(dbStateProvider.notifier).updateTodo(
                                  currentTodo.copyWith(isCompleted: 0));
                            }
                          }
                        },
                        value: currentTodo.isCompleted == 0 ? false : true,
                      ),
                      trailing: SizedBox(
                        width: 100,
                        height: 50,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (currentTodo.id != null) {
                                  ref
                                      .read(dbStateProvider.notifier)
                                      .deleteToDo(currentTodo.id!);
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref.read(dbStateProvider.notifier).updateTodo(
                                    ToDo(
                                        id: currentTodo.id,
                                        title: "New",
                                        description: currentTodo.description,
                                        isCompleted: currentTodo.isCompleted));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: data.length,
                );
              },
            );
      },
    );
  }
}
