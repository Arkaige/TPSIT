import 'package:flutter/material.dart';

void main() {
  runApp(MyStopWatchApp());
}

class MyStopWatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StopWatchPage(),
    );
  }
}

class StopWatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cronometro"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "00:00",
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "minuti : secondi",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              
            },
            icon: Icon(Icons.play_arrow),
            label: Text("START"),
          ),
          SizedBox(width: 10),
          FloatingActionButton.extended(
            onPressed: () {
              
            },
          
            icon: Icon(Icons.pause),
            label: Text("PAUSE"),
          ),
        ],
      ),
    );
  }
}
