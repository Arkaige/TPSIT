import 'package:flutter/material.dart';
import 'model.dart';

class TodoItem extends StatefulWidget {
  Todo todo;
  Function onDelete;
  Function onCheck;
  Function onChange;

  TodoItem(this.todo, this.onDelete, this.onCheck, this.onChange);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  TextEditingController controller = TextEditingController();
  bool edit = false;

  @override
  void initState() {
    super.initState();
    controller.text = widget.todo.name;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.todo.checked,
          onChanged: (value) {
            widget.onCheck(widget.todo);
          },
        ),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: edit == false,
            decoration: InputDecoration(
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
          icon: Icon(Icons.delete, color: Colors.orange),
          onPressed: () {
            widget.onDelete(widget.todo);
          },
        ),
      ],
    );
  }
}
