import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/provider/category_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          return ref.watch(categoryProvider).when(
              data: (data) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _CategoryCard(category: data[index]);
                  },
                  itemCount: data.length,
                );
              },
              error: (error, s) => Text("ERROR"),
              loading: () => CircularProgressIndicator());
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(categoryProvider.notifier).insertCategory(Category(
              id: null,
              title: "New",
              color: Colors.blue.value,
              total: 10,
              completed: 4));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  const _CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/todos", arguments: category.id);
          },
          child: Card(
            color: Color(category.color),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 28),
                        ),
                        Consumer(builder: (context, ref, child) {
                          return IconButton(
                            onPressed: () {
                              ref
                                  .read(categoryProvider.notifier)
                                  .deleteCategory(category.id!);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.white,
                          );
                        })
                      ],
                    ),
                    Text(
                      category.completed.toString() +
                          "/" +
                          category.total.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      value: (category.completed / category.total),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
