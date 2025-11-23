import 'dart:io';

void main() async {
  List<Socket> clients = [];
  Map<Socket, String> clientNames = {}; // Salva nome dei client per socket

  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
  print("Server executed on port 3000");

  server.listen((client) {
    clients.add(client);

    // Primo messaggio dal client contiene il nome
    client.listen((data) {
      String msg = String.fromCharCodes(data).trim();
      
      // Connessione di un client
      if (!clientNames.containsKey(client)) {
        String name = msg.split(" ")[0];
        clientNames[client] = name;
        print("CONNECTED ${client.remoteAddress.address}/$name");
      } else {
        print(msg);
      }

      // Manda il messaggio agli altri client
      for (var c in clients) {
        if (c != client) {
          c.write(msg + "\n");
        }
      }
    }, onDone: () {
      String? name = clientNames[client];
      print("DISCONNECTED ${client.remoteAddress.address}/$name");

      for (var c in clients) {
        if (c != client) {
          c.write("$name has left the chatroom\n");
        }
      }

      clients.remove(client);
      clientNames.remove(client);
    });
  });
}
