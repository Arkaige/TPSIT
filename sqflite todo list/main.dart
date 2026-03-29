import 'package:flutter/material.dart';
import 'model.dart';
import 'widgets.dart';
import 'helper.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    List<Note> list = await DatabaseHelper.getNotes();
    setState(() {
      notes = list;
    });
  }

  void addNote() async {
    Note n = Note('', []);
    int id = await DatabaseHelper.insertNote();
    n.id = id;
    setState(() {
      notes.add(n);
    });
  }

  void deleteNote(Note n) async {
    await DatabaseHelper.deleteNote(n);
    setState(() {
      notes.remove(n);
    });
  }

  void addTodo(Note n) async {
    Todo t = Todo('', false);
    t.noteId = n.id;
    int id = await DatabaseHelper.insertTodo(t);
    t.id = id;
    setState(() {
      n.todos.add(t);
    });
  }

  void deleteTodo(Note n, Todo t) async {
    await DatabaseHelper.deleteTodo(t);
    setState(() {
      n.todos.remove(t);
    });
  }

  void toggleTodo(Todo t) async {
    setState(() {
      t.checked = !t.checked;
    });
    await DatabaseHelper.updateTodo(t);
  }

  void changeText(Todo t, String txt) async {
    setState(() {
      t.name = txt;
    });
    await DatabaseHelper.updateTodo(t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('zKeep'),
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: notes.length,
        itemBuilder: (context, i) {
          Note n = notes[i];
          return Card(
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Titolo...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (txt) {
                          setState(() {
                            n.title = txt;
                          });
                          DatabaseHelper.updateNote(n);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.blue),
                      onPressed: () {
                        addTodo(n);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteNote(n);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: n.todos.length,
                    itemBuilder: (context, j) {
                      return TodoItem(
                        n.todos[j],
                        (t) { deleteTodo(n, t); },
                        toggleTodo,
                        changeText,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNote();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
