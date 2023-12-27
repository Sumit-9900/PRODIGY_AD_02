import 'package:hive/hive.dart';
import 'package:todo_list_3/models/todo_model.dart';

class Boxes {
  static Box<ToDo> getData() => Hive.box<ToDo>('todo');
}
