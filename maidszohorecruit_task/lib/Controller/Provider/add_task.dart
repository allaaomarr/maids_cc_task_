import 'package:flutter/material.dart';
import 'package:maidszohorecruit_task/Model/addtask_model.dart';

import '../data/dio.dart';

class addtaskProvider with ChangeNotifier {
  List<addtask> _todos = [];
  bool _isLoading = false;

  List<addtask> get todos => _todos;
  bool get isLoading => _isLoading;

  Future<void> addTodoItem(String todoText, int userId) async {
    _isLoading = true;
    notifyListeners();

    addtask? newTodo = await ApiServices.addTodoItem(addtask(
      todo: todoText,
      completed: false,
      userId: userId,
    ));

    if (newTodo != null) {
      _todos.add(newTodo);
    }

    _isLoading = false;
    notifyListeners();
  }
}