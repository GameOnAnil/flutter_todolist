import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/provider/db_notifier.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoPage extends StatelessWidget {
  final int categoryId;
  const TodoPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addItemPage", arguments: categoryId);
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
                "What's up,Anil!  " + categoryId.toString(),
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202B54)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text("Todays Task",
                  style: TextStyle(
                      color: const Color(0xFF202B54).withOpacity(0.5),
                      fontWeight: FontWeight.bold)),
            ),
            const Expanded(child: ListPart()),
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
        icon: const Icon(Icons.arrow_back),
        iconSize: 25.0,
        color: Colors.black87,
        onPressed: () {
          Navigator.of(context).pop();
        },
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
                    return CustomTile(todo: currentTodo);
                  },
                  itemCount: data.length,
                );
              },
            );
      },
    );
  }
}

class CustomTile extends ConsumerWidget {
  final ToDo todo;
  const CustomTile({required this.todo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                if (todo.id != null) {
                  ref.read(dbStateProvider.notifier).deleteToDo(todo.id!);
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              onPressed: (BuildContext context) {
                ref.read(dbStateProvider.notifier).updateTodo(ToDo(
                    id: todo.id,
                    title: "New",
                    description: todo.description,
                    isCompleted: todo.isCompleted,
                    date: todo.date,
                    time: todo.time));
              },
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          width: MediaQuery.of(context).size.width,
          height: 70,
          child: Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                      width: 1.8, color: Theme.of(context).primaryColor),
                ),
                onChanged: (value) {
                  if (value != null) {
                    if (value == true) {
                      ref
                          .read(dbStateProvider.notifier)
                          .updateTodo(todo.copyWith(isCompleted: 1));
                    } else {
                      ref
                          .read(dbStateProvider.notifier)
                          .updateTodo(todo.copyWith(isCompleted: 0));
                    }
                  }
                },
                value: todo.isCompleted == 0 ? false : true,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      todo.description,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        todo.date,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        todo.time,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
