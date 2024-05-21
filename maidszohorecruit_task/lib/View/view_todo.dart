import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maidszohorecruit_task/Model/view_tasks.dart';
import 'package:maidszohorecruit_task/Controller/Provider/view_task_provider.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<ViewProvider>(context, listen: false).ViewallTasks();
    });
  }

  bool _taskCompleted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tasks'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ViewProvider>(
        builder: (context, viewProvider, child) {
          if (viewProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: viewProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = viewProvider.todos[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo.completed,
                          onChanged: (bool? value) async {
                            if (value != null) {



                              await Provider.of<ViewProvider>(context, listen: false).updateTaskCompletion(todo.id, value);

                              _showSuccessAlert('Changed Successfully');
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Delete the task
                            await Provider.of<ViewProvider>(context, listen: false).deleteTask(todo.id);
                            // Show success alert
                            _showSuccessAlert('Task Deleted Successfully');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to show a success alert
  void _showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
