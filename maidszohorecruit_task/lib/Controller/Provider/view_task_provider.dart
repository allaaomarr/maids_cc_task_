import 'package:flutter/cupertino.dart';

import '../../Model/view_tasks.dart';
import '../data/dio.dart';

class ViewProvider with ChangeNotifier {
  List<viewModel> _todos = [];
  bool _isLoading = false;
  List<viewModel> get todos => _todos;
  bool get isLoading => _isLoading;

  final ApiServices _todoService = ApiServices();

  Future<void> ViewallTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _todoService.ViewTasks();
    } catch (e) {
      print('Error fetching to-dos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateTaskCompletion(int taskId, bool completed) async {
    try {
      // Make API call to update task completion status
      await _todoService.updateTask(taskId, completed);
      // Update local task list
      final index = _todos.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _todos[index].completed = completed;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task completion status: $e');
    }
  }
  Future<bool> deleteTask(int id) async {
    try {
      bool success = await ApiServices.deleteTodoItem(id);
      if (success) {
        print('Task deleted successfully');
      } else {
        print('Failed to delete task');
      }
      return success;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }
}


