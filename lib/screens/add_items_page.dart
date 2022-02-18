import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/provider/add_item_notifier.dart';
import 'package:todo_app/provider/db_notifier.dart';

final addItemChangeNotifierProvider =
    ChangeNotifierProvider<AddItemNotifier>((_) => AddItemNotifier());

class AddItemsPage extends ConsumerStatefulWidget {
  final int categoryId;

  AddItemsPage({required this.categoryId});

  @override
  _AddItemsPageState createState() => _AddItemsPageState();
}

class _AddItemsPageState extends ConsumerState<AddItemsPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    var provider = ref.read(addItemChangeNotifierProvider);
    _titleController = TextEditingController(text: provider.title);
    _descriptionController = TextEditingController(text: provider.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Items" + widget.categoryId.toString(),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: Consumer(builder: (context, ref, child) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await ref.read(addItemChangeNotifierProvider).reset();
              Navigator.of(context).pop();
            },
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Title",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
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
                        ref.read(addItemChangeNotifierProvider).setTitle(value);
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
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  height: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.7), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    maxLines: 6,
                    controller: _descriptionController,
                    onChanged: (value) => ref
                        .read(addItemChangeNotifierProvider)
                        .setDescription(value),
                    decoration: const InputDecoration(
                        hintText: "Enter Description",
                        border: InputBorder.none),
                    style: const TextStyle(fontSize: 15),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Description cannot be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Due Date",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.7), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Consumer(
                            builder: (context, ref, child) {
                              var date =
                                  ref.watch(addItemChangeNotifierProvider).date;
                              var dateError = ref
                                  .watch(addItemChangeNotifierProvider)
                                  .dateError;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      date == null
                                          ? "Enter Due Time"
                                          : date.toString(),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    Text(
                                      dateError,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 10),
                                    )
                                  ],
                                ),
                              );
                            },
                          )),
                    ),
                    Consumer(builder: (context, ref, child) {
                      return IconButton(
                          onPressed: () {
                            _pickDate(context, ref);
                          },
                          icon: const Icon(Icons.calendar_today));
                    })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Due Time",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.7), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Consumer(
                            builder: (context, ref, child) {
                              var time =
                                  ref.watch(addItemChangeNotifierProvider).time;
                              var timeError = ref
                                  .watch(addItemChangeNotifierProvider.notifier)
                                  .timeError;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        time == null || time.isEmpty
                                            ? "Enter Due Time"
                                            : time.toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      Text(
                                        timeError,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 10),
                                      )
                                    ],
                                  ),
                                  Visibility(
                                    visible: time == null || time.isEmpty
                                        ? false
                                        : true,
                                    child: IconButton(
                                      onPressed: () {
                                        ref
                                            .read(addItemChangeNotifierProvider)
                                            .clearTime();
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  )
                                ],
                              );
                            },
                          )),
                    ),
                    Consumer(builder: (context, ref, child) {
                      return IconButton(
                        onPressed: () {
                          _pickTime(context, ref);
                        },
                        icon: const Icon(Icons.timer),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 10),
                ColorPicker(),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Consumer(builder: (context, ref, child) {
                      return TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            bool isValidated = await ref
                                .read(addItemChangeNotifierProvider)
                                .validate();
                            if (isValidated) {
                              ToDo todo = await ref
                                  .read(addItemChangeNotifierProvider)
                                  .getToDo(widget.categoryId);
                              await ref
                                  .read(dbStateProvider(widget.categoryId)
                                      .notifier)
                                  .insertToDo(todo);
                              ref.read(addItemChangeNotifierProvider).reset();
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row ColorPicker() {
    return Row(
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
    );
  }
}

Future _pickDate(BuildContext context, WidgetRef ref) async {
  final initialDate = DateTime.now();
  final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5));
  if (newDate == null) return null;

  ref.read(addItemChangeNotifierProvider).setDate(newDate);
}

Future _pickTime(BuildContext context, WidgetRef ref) async {
  final initialTime = TimeOfDay.now();
  final newTime =
      await showTimePicker(context: context, initialTime: initialTime);

  if (newTime == null) return null;

  final localizations = MaterialLocalizations.of(context);
  final formattedTimeOfDay = localizations.formatTimeOfDay(newTime);

  ref.read(addItemChangeNotifierProvider).setTime(formattedTimeOfDay);
}

class ColoredBox extends StatelessWidget {
  final Color color;
  const ColoredBox({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
    );
  }
}
