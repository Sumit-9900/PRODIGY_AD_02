import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_3/models/todo_model.dart';
import 'package:todo_list_3/provider/todo_provider.dart';
import 'package:todo_list_3/screens/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(ToDoAdapter());
  await Hive.openBox<ToDo>('todo');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ToDoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      home: HomeScreen(),
    );
  }
}
