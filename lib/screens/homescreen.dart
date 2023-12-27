import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_3/hive_boxes/boxes.dart';
import 'package:todo_list_3/models/todo_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titlecontroller = TextEditingController();

    Future<void> add() async {
      final data = ToDo(title: titlecontroller.text);
      final box = Boxes.getData();

      await box.add(data);

      await data.save();

      titlecontroller.clear();

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    void adddialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add ToDo'),
          content: TextField(
            controller: titlecontroller,
            decoration: const InputDecoration(
              hintText: 'Enter ToDo',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: add,
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                titlecontroller.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }

    Future<void> edit(ToDo todo) async {
      todo.title = titlecontroller.text;

      await todo.save();

      titlecontroller.clear();

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    void editdialog(ToDo todo, String title) {
      titlecontroller.text = title;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Edit ToDo'),
          content: TextField(
            controller: titlecontroller,
            decoration: const InputDecoration(
              hintText: 'Edit ToDo',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                edit(todo);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                titlecontroller.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(200, 167, 194, 208),
      ),
      body: ValueListenableBuilder<Box<ToDo>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var dabba = box.values.toList().cast<ToDo>();
          return ListView.builder(
            itemCount: dabba.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 22.0,
                  right: 22.0,
                  top: 26.0,
                  bottom: 0.0,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(198, 119, 168, 192),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  title: Text(dabba[index].title),
                  leading: Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  trailing: SizedBox(
                    width: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            editdialog(
                              dabba[index],
                              titlecontroller.text,
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            await dabba[index].delete();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(200, 167, 194, 208),
        onPressed: adddialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
