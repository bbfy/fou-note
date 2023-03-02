import 'package:flutter/material.dart';

import 'package:custom_note/elements/solo.dart';

class TodoProvider extends ChangeNotifier {
  List<Solo> checkedTodoList = <Solo>[];

  addTodoList(Solo todo) {
    checkedTodoList.add(todo);
  }

  delTodoList(Solo todo) {
    checkedTodoList.removeWhere((element) => element.id == todo.id);
  }

  get getCheckedTodoList => checkedTodoList;
}
