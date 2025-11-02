import 'dart:async';
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

class StopWatchPage extends StatefulWidget {
  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  int secondi = 0;
  Timer? timer;
  bool isRunning = false;

 
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondi++;
      });
    });
  }


  void stopTimer() {
    timer?.cancel();
  }


  void resetTimer() {
    timer?.cancel();
    setState(() {
      secondi = 0;
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int minuti = secondi ~/ 60;
    int sec = secondi % 60;

    String minStr = minuti.toString().padLeft(2, '0');
    String secStr = sec.toString().padLeft(2, '0');

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
              "$minStr:$secStr",
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "minuti : secondi",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                if (!isRunning) {
                  startTimer();
                  setState(() {
                    isRunning = true;
                  });
                } else {
                  stopTimer();
                  setState(() {
                    isRunning = false;
                  });
                }
              },
              icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
              label: Text(isRunning ? "STOP" : "START"),
            ),
            SizedBox(width: 10),
            FloatingActionButton.extended(
              onPressed: () {
                resetTimer();
              },
          
              icon: Icon(Icons.refresh),
              label: Text("RESET"),
            ),
          ],
        ),
      ),
    );
  }
}
