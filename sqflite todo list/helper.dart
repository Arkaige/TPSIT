import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class DatabaseHelper {
  static Future<Database> init() async {
    // get path
    String path = join(await getDatabasesPath(), 'zkeep.db');

    // open/create the database
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute(
      'CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)'
    );
    await db.execute(
      'CREATE TABLE todos (id INTEGER PRIMARY KEY AUTOINCREMENT, noteId INTEGER, name TEXT, checked INTEGER)'
    );
  }

  
//note
  static Future<List<Note>> getNotes() async {
    Database db = await init();
    List<Map<String, dynamic>> righeNote = await db.query('notes');
    List<Map<String, dynamic>> righeTodos = await db.query('todos');

    List<Note> notes = [];
    for (int i = 0; i < righeNote.length; i++) {
      Note n = Note(righeNote[i]['title'], []);
      n.id = righeNote[i]['id'];

      for (int j = 0; j < righeTodos.length; j++) {
        if (righeTodos[j]['noteId'] == n.id) {
          Todo t = Todo(righeTodos[j]['name'], righeTodos[j]['checked'] == 1);
          t.id = righeTodos[j]['id'];
          t.noteId = n.id;
          n.todos.add(t);
        }
      }

      notes.add(n);
    }
    return notes;
  }

  static Future<int> insertNote() async {
    Database db = await init();
    Map<String, dynamic> mappa = {};
    mappa['title'] = '';
    int id = await db.insert('notes', mappa);
    return id;
  }

  static Future<void> updateNote(Note n) async {
    Database db = await init();
    Map<String, dynamic> mappa = {};
    mappa['title'] = n.title;
    await db.update('notes', mappa, where: 'id = ?', whereArgs: [n.id]);
  }

  static Future<void> deleteNote(Note n) async {
    Database db = await init();
    await db.delete('todos', where: 'noteId = ?', whereArgs: [n.id]);
    await db.delete('notes', where: 'id = ?', whereArgs: [n.id]);
  }

  
//todo
  static Future<int> insertTodo(Todo todo) async {
    Database db = await init();
    Map<String, dynamic> mappa = {};
    mappa['noteId'] = todo.noteId;
    mappa['name'] = todo.name;
    mappa['checked'] = 0;
    int id = await db.insert('todos', mappa);
    return id;
  }

  static Future<void> updateTodo(Todo todo) async {
    Database db = await init();
    Map<String, dynamic> mappa = {};
    mappa['noteId'] = todo.noteId;
    mappa['name'] = todo.name;
    mappa['checked'] = todo.checked ? 1 : 0;
    await db.update('todos', mappa, where: 'id = ?', whereArgs: [todo.id]);
  }

  static Future<void> deleteTodo(Todo todo) async {
    Database db = await init();
    await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
  }
}
