import 'dart:io';

void main() async {
  print("Enter your name:");
  String? name = stdin.readLineSync();

  if (name == null || name.isEmpty) {
    print("Invalid name. Exiting.");
    return;
  }

  // Connessione al server
  final socket = await Socket.connect('127.0.0.1', 3000);
  print('Connected to chat server as $name.');

  socket.write('$name has joined the chat.\n');

 
  socket.listen((data) {
    print(String.fromCharCodes(data).trim());
  });

  // Input keyboard
  stdin.listen((data) {
    socket.write('$name: ${String.fromCharCodes(data)}');
  });
}
