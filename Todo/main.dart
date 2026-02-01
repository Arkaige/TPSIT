import 'package:flutter/material.dart';
import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  
  List<Todo> todos = [];

  void addTodo() {
    setState(() {
      todos.add(Todo(name: '', checked: false));
    });
  }

  void deleteTodo(Todo t) {
    setState(() {
      todos.remove(t);
    });
  }

  void toggleTodo(Todo t) {
    setState(() {
      t.checked = !t.checked;
    });
  }

  void changeText(Todo t, String txt) {
    setState(() {
      t.name = txt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo list'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, i) {
          return TodoItem(
            todo: todos[i],
            onDelete: deleteTodo,
            onCheck: toggleTodo,
            onChange: changeText,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
