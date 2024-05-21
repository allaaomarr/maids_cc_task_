
import 'package:dio/dio.dart';
import 'package:maidszohorecruit_task/Model/addtask_model.dart';
import 'package:maidszohorecruit_task/Model/view_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/login_model.dart';
class ApiServices {

  static Future<int?>  PostDatalogin(username, password,) async {
final dio = Dio();
SharedPreferences prefs = await SharedPreferences.getInstance();

    try {

      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 30, // optional, defaults to 60
        },

     //   onSendProgress: onSendProgress,
       // onReceiveProgress: onReceiveProgress,
      );
   int?    success =  response.statusCode;
      print(response.statusCode);
      if (response.statusCode == 200) {
print("successful login");
print(response.data['id']);
prefs.setInt("id",response.data['id']);
print(prefs.getInt("id"));
return response.statusCode;
      }
      else {
     print("error");
     return response.statusCode;
      }

    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }


      throw Exception(ex.message);

    }

  }

  static Future<addtask?> addTodoItem(addtask todo) async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("id");


    List<String> _todoList = prefs.getStringList('todoList') ?? [];


    _todoList.add(todo.todo);


    await prefs.setStringList('todoList', _todoList);


    List<String>? list = prefs.getStringList('todoList');
    print(list);
    print(userId);
    try {
      final response = await dio.post(
        'https://dummyjson.com/todos/add',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: todo.toJson(),
      );

      if (response.statusCode == 200) {
        print(response.data);
        return addtask.fromJson(response.data);

      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectionTimeout) {
        throw Exception("Connection Timeout Exception");
      } else {
        throw Exception(ex.message);
      }
    }
  }
  static Future<bool> deleteTodoItem(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("id");
    final dio = Dio();
    print('Deleting task with ID: $id for user ID: $userId');

    try {
      final response = await dio.delete(
        'https://dummyjson.com/todos/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Task deleted successfully');
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } on DioError catch (ex) {
      if (ex.type == DioErrorType.connectionTimeout) {
        throw Exception("Connection Timeout Exception");
      } else {
        print('Dio error: ${ex.message}');
        return false;
      }
    }
  }


  Future<List<viewModel>> ViewTasks() async {
    final dio = Dio();
    try {
      final response = await dio.get('https://dummyjson.com/todos', queryParameters: {
        'limit': 10,
        'skip': 0, // Adjust skip value based on your pagination requirements
      });
      if (response.statusCode == 200) {
        // Ensure 'todos' field is correctly accessed
        List<dynamic> data = response.data['todos'];
        List<viewModel> items = data.map((item) => viewModel.fromJson(item)).toList();
        print(response.data);
        return items;
      } else {
        throw Exception('Failed to load to-dos');
      }
    } on DioError catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }
  Future<void> updateTask(int taskId, bool completed) async {
    final dio = Dio();
    try {
      final response = await dio.put(
        'https://dummyjson.com/todos/$taskId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'completed': completed,
        },
      );

      if (response.statusCode == 200) {
        print('Task updated successfully: ${response.data}');
      } else {
        print('Failed to update task: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Dio error: ${e.message}');
    }
  }

}