import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/provider/add_category_notifier.dart';
import 'package:todo_app/provider/category_provider.dart';

final addCategoryProvider =
    ChangeNotifierProvider<AddCategoryNotifier>((_) => AddCategoryNotifier());

class AddCategoryPage extends ConsumerStatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    var provider = ref.read(addCategoryProvider);
    _titleController = TextEditingController(text: provider.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.85),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await ref.read(addCategoryProvider).reset();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.7), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        ref.read(addCategoryProvider).setTitle(value);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Title",
                      ),
                      style: const TextStyle(fontSize: 15),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Title cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    ColoredBox(
                      color: Colors.pink,
                    ),
                    ColoredBox(
                      color: Colors.blue,
                    ),
                    ColoredBox(
                      color: Colors.green,
                    ),
                    ColoredBox(
                      color: Colors.indigo,
                    ),
                    ColoredBox(
                      color: Colors.yellow,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Consumer(builder: (context, ref, child) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var title =
                              ref.read(addCategoryProvider.notifier).title;
                          var color =
                              ref.read(addCategoryProvider.notifier).color;

                          await ref
                              .read(categoryProvider.notifier)
                              .insertCategory(Category(
                                  id: null,
                                  title: title,
                                  color: color,
                                  total: 0,
                                  completed: 0));
                          await ref.read(addCategoryProvider).reset();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColoredBox extends StatelessWidget {
  final Color color;
  const ColoredBox({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: () {
          ref.read(addCategoryProvider).setColor(color.value);
        },
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
              border: color.value == ref.watch(addCategoryProvider).color
                  ? Border.all(width: 2, color: Colors.white)
                  : null),
        ),
      );
    });
  }
}
