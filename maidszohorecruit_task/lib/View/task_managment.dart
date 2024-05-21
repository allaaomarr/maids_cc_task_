import 'package:flutter/material.dart';
import 'package:maidszohorecruit_task/Controller/data/dio.dart';
import 'package:maidszohorecruit_task/View/view_todo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Provider/add_task.dart';
import '../Controller/Provider/view_task_provider.dart';

class TaskManagement extends StatefulWidget {
  const TaskManagement({Key? key}) : super(key: key);

  @override
  State<TaskManagement> createState() => _TaskManagementState();
}

class _TaskManagementState extends State<TaskManagement> {
  @override
  void initState() {
    super.initState();

  }
  Future<void> _deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _todoList = prefs.getStringList('todoList') ?? [];
    setState(() {
      _todoList.removeAt(index);
    });
    await prefs.setStringList('todoList', _todoList);
  }
  TextEditingController taskController = TextEditingController();
  bool _taskCompleted = false;
  final ApiServices _apiServices = ApiServices();
  //final int _taskId = 1;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => addtaskProvider()),
        ChangeNotifierProvider(create: (_) => ViewProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Task Management"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer2<addtaskProvider, ViewProvider>(
            builder: (context, addTaskProvider, viewProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: "Enter Task",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.task),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      int? userId = prefs.getInt("id");
                      if (userId != null) {
                        await context.read<addtaskProvider>().addTodoItem(
                          taskController.text,
                          userId,
                        );
                        taskController.clear(); // Clear the input field after adding a task
                      }
                    },
                    child: Text("Add Task"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Recent Tasks",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                 Expanded(
                    child: ListView.builder(
                      itemCount: addTaskProvider.todos.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final task = addTaskProvider.todos[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(task.todo),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
    Checkbox(
    value: _taskCompleted,
    onChanged: (bool? value) async {
      await _apiServices.updateTask(1,value!);

    if (value != null) {
    setState(() {
    _taskCompleted = value;
    });
    }}),       IconButton(onPressed: ()async{
                                  setState(() async{

                                  await _deleteTask(index);
                                  });
                                },
                                  icon: Icon(Icons.delete, color: Colors.red,)),


                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
           /* SharedPreferences prefs = await SharedPreferences.getInstance();
            int? userId = prefs.getInt("id");
            if (userId != null) {
              Provider.of<ViewProvider>(context, listen: false).ViewallTasks();
            }*/
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
              return TaskListPage();
            }));
          },
          child: Icon(Icons.task_outlined),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}

