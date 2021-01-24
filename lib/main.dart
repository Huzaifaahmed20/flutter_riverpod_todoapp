import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:riverpod_todo_app/models/todo.dart';
import 'package:riverpod_todo_app/notifier/todo_notifier.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  Home({Key key}) : super(key: key);

  Future<dynamic> showEditDialog(BuildContext ctx, Todo item) {
    final editTodoText = TextEditingController(text: item.description);
    return showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: editTodoText,
        ),
        actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              context
                  .read(todoListProvider)
                  .edit(description: editTodoText.text, id: item.id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final descriptController = useTextEditingController();
    final todoList = useProvider(todoListProvider.state);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read(todoListProvider).addTodo(descriptController.text),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: descriptController,
            ),
          ),
          todoList.isEmpty
              ? Center(
                  child: Text('No todos yet'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final todoItem = todoList[index];

                      return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text('${todoItem.description}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => context
                                    .read(todoListProvider)
                                    .remove(todoItem.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () =>
                                    showEditDialog(context, todoItem),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
