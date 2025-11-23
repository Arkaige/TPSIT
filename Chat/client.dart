import 'dart:io';

void main() async {
  print("Enter username:");
  String? name = stdin.readLineSync();

  if (name == null || name.isEmpty) {
    print("User already taken. Exiting");
    return;
  }

  final socket = await Socket.connect('127.0.0.1', 3000);
  print("Connected to chatroom as $name");

  socket.write("$name has joined the chatroom.\n");

  // Ascolta i messaggi degli altri
  socket.listen((data) {
    print(String.fromCharCodes(data).trim());
  });

  // Legge i messaggi input
  stdin.listen((data) {
    String msg = String.fromCharCodes(data).trim();
    socket.write("$name: $msg\n");
  });
}
