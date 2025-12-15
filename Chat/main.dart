import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();

  // Connessione alla ChatPage
  void connect() {
    if (nameController.text.trim().isEmpty){
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(name: nameController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Chatroom")),
      body: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: connect,
                child: const Text("Join the chatroom"),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class ChatPage extends StatefulWidget {
  final String name;
  const ChatPage({super.key, required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Socket socket;
  final TextEditingController controller = TextEditingController();
  final List<String> messages = [];

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() async {
    try {
    
      socket = await Socket.connect('10.0.2.2', 3000);

      socket.write("${widget.name} has joined the chatroom\n");

      // Ascolta i messaggi dal server
      socket.listen((data) {
        setState(() {
          messages.add(String.fromCharCodes(data).trim());
        });
      }, onDone: () {
        socket.destroy();
        setState(() {
          messages.add("Connection closed");
        });
      });
    } catch (e) {
      setState(() {
        messages.add("Connection error: $e");
      });
    }
  }

  void sendMessage() {
    if (controller.text.trim().isEmpty) {
      return;
    }
  
    String msg = controller.text.trim();
    setState(() {
      messages.add("${widget.name}: $msg");
    });
    socket.write("${widget.name}: $msg\n");

      controller.clear();
    }
    

    String msg = controller.text.trim();
    socket.write("${widget.name}: $msg\n");

    controller.clear();
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatroom")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(messages[index]),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: ". . .",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
