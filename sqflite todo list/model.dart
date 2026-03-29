class Todo {
  int? id;
  int? noteId;
  String name;
  bool checked;
 
  Todo(this.name, this.checked);
}
 
class Note {
  int? id;
  String title;
  List<Todo> todos;
 
  Note(this.title, this.todos);
}
