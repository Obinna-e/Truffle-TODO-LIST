import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_dapp/controllers/TodoListController.dart';
import 'package:todo_dapp/widgets/BottomSheet.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoListController todolistcontroller = Get.put(TodoListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dapp Todo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      body: todolistcontroller.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todolistcontroller.todos.length,
                    itemBuilder: (context, index) => ListTile(
                      title: InkWell(
                        onTap: () {
                          showTodoBottomSheet(
                            context,
                            task: todolistcontroller.todos[index],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 12,
                          ),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value:
                                    todolistcontroller.todos[index].isCompleted,
                                onChanged: (val) {
                                  todolistcontroller.toggleComplete(
                                      todolistcontroller.todos[index].id);
                                },
                              ),
                              Text(todolistcontroller.todos[index].taskName),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
