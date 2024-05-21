import 'package:flutter/material.dart';
import 'package:maidszohorecruit_task/View/login.dart';
import 'package:maidszohorecruit_task/Controller/data/dio.dart';
import 'package:maidszohorecruit_task/View/task_managment.dart';
import 'package:maidszohorecruit_task/View/view_todo.dart';
import 'package:provider/provider.dart';

import 'Controller/Provider/add_task.dart';
import 'Controller/Provider/view_task_provider.dart';
void main() {
  runApp(   MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => addtaskProvider()),
      ChangeNotifierProvider(create: (_) => ViewProvider()),
    ],
    child: MyApp(),
  ),);
 // ApiServices().PostDatalogin("atuny0", "9uQFF1Lh");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Login()
    );
  }
}

