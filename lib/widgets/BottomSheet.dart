import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_dapp/controllers/TodoListController.dart';
import 'package:todo_dapp/models/taskModel.dart';

showTodoBottomSheet(BuildContext context, {Task? task}) {
  TextEditingController _titleController =
      TextEditingController(text: task?.taskName ?? "");
  TodoListController listController = Get.put(TodoListController());
  return showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 10),
          margin: const EdgeInsets.all(10),
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 14,
                      bottom: 20,
                      top: 20,
                    ),
                    hintText: 'Enter a search term',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                if (task == null)
                  buildButton("Created", () {
                    listController.addTask(_titleController.text);
                    Navigator.pop(context);
                  }),
                if (task != null)
                  buildButton("Updated", () {
                    listController.updateTask(task.id, _titleController.text);
                    Navigator.pop(context);
                  }),
                if (task != null)
                  buildButton("Delete", () {
                    listController.deleteTask(task.id);
                    Navigator.pop(context);
                  }),
              ],
            ),
          ),
        );
      });
}

TextButton buildButton(String text, VoidCallback onPressed) {
  return TextButton(
    onPressed: onPressed,
    child: Container(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: text == "Delete" ? Colors.red : Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
