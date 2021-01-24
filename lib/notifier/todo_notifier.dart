import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:riverpod_todo_app/models/todo.dart';

final todoListProvider = StateNotifierProvider((ref) => TodoList([]));

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo> initialTodos]) : super(initialTodos ?? []);

  void addTodo(String description) {
    state = [
      ...state,
      Todo(description: description),
    ];
  }

  void edit({@required String id, @required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
