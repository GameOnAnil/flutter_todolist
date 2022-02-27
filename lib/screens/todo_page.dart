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
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black.withOpacity(0.85),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Text(
                  "What's up,Anil!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Text("Todays Task",
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.75),
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: ListPart(
                categoryId: categoryId,
              )),
            ],
          ),
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
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          iconSize: 25.0,
          color: Colors.white,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
          ),
          iconSize: 25.0,
          color: Colors.white,
        ),
      ],
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }
}

class ListPart extends StatelessWidget {
  final int categoryId;
  const ListPart({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(dbStateProvider(categoryId)).when(
              error: (e, s) => const Center(child: Text("ERROR")),
              loading: () => const CircularProgressIndicator(),
              data: (data) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    ToDo currentTodo = data[index];
                    return CustomTile(
                        todo: currentTodo, categoryId: categoryId);
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
  final int categoryId;
  final ToDo todo;
  const CustomTile({required this.categoryId, required this.todo, Key? key})
      : super(key: key);

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
                  ref
                      .read(dbStateProvider(categoryId).notifier)
                      .deleteToDo(todo.id!);
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
                ref.read(dbStateProvider(categoryId).notifier).updateTodo(ToDo(
                    id: todo.id,
                    title: "New",
                    description: todo.description,
                    isCompleted: todo.isCompleted,
                    date: todo.date,
                    time: todo.time,
                    categoryId: todo.categoryId));
              },
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
          ),
          width: MediaQuery.of(context).size.width,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Checkbox(
                  activeColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(
                        width: 1.8,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      if (value == true) {
                        ref
                            .read(dbStateProvider(categoryId).notifier)
                            .updateTodo(todo.copyWith(isCompleted: 1));
                      } else {
                        ref
                            .read(dbStateProvider(categoryId).notifier)
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        todo.description,
                        maxLines: 2,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
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
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12),
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
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12),
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
      ),
    );
  }
}
