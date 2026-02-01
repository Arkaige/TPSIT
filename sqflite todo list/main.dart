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

  List<Note> notes = [];

  void addNote() {
    setState(() {
      notes.add(Note(todos: []));
    });
  }

  void deleteNote(Note n) {
    setState(() {
      notes.remove(n);
    });
  }

  void addTodo(Note n) {
    setState(() {
      n.todos.add(Todo(name: '', checked: false));
    });
  }

  void deleteTodo(Note n, Todo t) {
    setState(() {
      n.todos.remove(t);
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
        title: const Text('zKeep'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, i) {
          final note = notes[i];

          return Card(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteNote(note);
                      },
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: note.todos.length,
                  itemBuilder: (context, j) {
                    return TodoItem(
                      todo: note.todos[j],
                      onDelete: (t) => deleteTodo(note, t),
                      onCheck: toggleTodo,
                      onChange: changeText,
                    );
                  },
                ),
                TextButton(
                  onPressed: () => addTodo(note),
                  child: const Text('aggiungi todo'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
