import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class ToDo extends HiveObject {
  ToDo({
    required this.title,
  });

  @HiveField(0)
  String title;
}
