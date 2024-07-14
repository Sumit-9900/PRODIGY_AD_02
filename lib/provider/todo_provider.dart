import 'package:flutter/material.dart';
import 'package:todo_list_3/hive_boxes/boxes.dart';
import 'package:todo_list_3/models/todo_model.dart';

class ToDoProvider extends ChangeNotifier {
  bool _pop = false;
  bool get pop => _pop;

  List<ToDo> _checkedToDos = [];
  List<ToDo> get checkedToDos => _checkedToDos;

  Future<void> add(TextEditingController titlecontroller) async {
    final data = ToDo(title: titlecontroller.text);
    final box = Boxes.getData();

    await box.add(data);

    await data.save();

    titlecontroller.clear();

    _pop = true;
    notifyListeners();
  }

  Future<void> edit(ToDo todo, TextEditingController textcontroller) async {
    todo.title = textcontroller.text;

    await todo.save();

    textcontroller.clear();

    _pop = true;
    notifyListeners();
  }

  void checkBox(bool? value, ToDo box) {
    if (value != null) {
      box.check = value;
    }
    notifyListeners();
  }

  void getToDos() {
    _checkedToDos.clear();
    final box = Boxes.getData();
    for (int i = 0; i < box.values.toList().length; i++) {
      ToDo? todo = box.getAt(i);
      if (todo != null) {
        _checkedToDos.add(todo);
      }
    }
  }

  Future<void> deleteToDo(int index) async {
    final box = Boxes.getData();
    await box.deleteAt(index);
    notifyListeners();
  }

  Future<void> clearToDo() async {
    for (int i = 0; i < _checkedToDos.length; i++) {
      if (_checkedToDos[i].check == true) {
        await _checkedToDos[i].delete();
      }
    }
    notifyListeners();
  }
}
