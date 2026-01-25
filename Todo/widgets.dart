import 'package:flutter/material.dart';
import 'model.dart';

class TodoItem extends StatefulWidget {

  const TodoItem({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onCheck,
    required this.onChange,
  });

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) onCheck;
  final Function(Todo, String) onChange;
  @override
  State<TodoItem> createState() => TodoItemState();
}


class TodoItemState extends State<TodoItem> {

  var controller = TextEditingController();
  bool edit = false;
  @override
  void initState() {
    super.initState();
    controller.text = widget.todo.name;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Checkbox(
            value: widget.todo.checked,
            onChanged: (_) {
              widget.onCheck(widget.todo);
            },
          ),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: !edit,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '. . .',
              ),
              onTap: () {
                setState(() {
                  edit = true;
                });
              },
              onEditingComplete: () {
                widget.onChange(widget.todo, controller.text);
                setState(() {
                  edit = false;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              widget.onDelete(widget.todo);
            }, 
          ),
        ],
      ),
    );
  }
}
