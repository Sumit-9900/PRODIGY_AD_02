import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_3/provider/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titlecontroller = TextEditingController();
  final textcontroller = TextEditingController();

  @override
  void dispose() {
    titlecontroller.dispose();
    textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToDoProvider>(context);
    provider.getToDos();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(200, 167, 194, 208),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Column(
          children: [
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                hintText: 'Enter ToDo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    await provider.add(titlecontroller);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('New ToDo has been added!!!'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.done),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: provider.checkedToDos.length,
                itemBuilder: (context, index) {
                  final dabba = provider.checkedToDos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(198, 119, 168, 192),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        title: Text(
                          dabba.title,
                          style: TextStyle(
                            decoration: dabba.check == true
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        leading: Checkbox(
                          value: dabba.check,
                          onChanged: (value) {
                            provider.checkBox(value, dabba);
                          },
                        ),
                        trailing: SizedBox(
                          width: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Edit ToDo'),
                                      content: TextField(
                                        controller: textcontroller,
                                        decoration: const InputDecoration(
                                          hintText: 'Edit ToDo',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            provider.edit(
                                                dabba, textcontroller);
                                            if (provider.pop) {
                                              Navigator.of(context).pop();
                                            }
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'ToDo has been edited!!!'),
                                              ),
                                            );
                                          },
                                          child: const Text('Edit'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            textcontroller.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await provider.deleteToDo(index);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'ToDo has been deleted!!!',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await provider.clearToDo();
                if (context.mounted && provider.checkedToDos.isNotEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All completed ToDos are removed!!!'),
                    ),
                  );
                } else if (context.mounted && provider.checkedToDos.isEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No ToDos to clear!!!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(200, 167, 194, 208),
                foregroundColor: Colors.black,
              ),
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}
