import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),debugShowCheckedModeBanner: false);
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Colori disponibili
  List<Color> colori = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
  
  // Colori iniziali
  List<Color> scelti = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];

  List<Color> segreto = [];

  @override
  void initState() {
    super.initState();
    generaCodice();
  }

  void generaCodice() {
    Random r = Random();
    segreto = [];
    for (int i = 0; i < 4; i++) {
      segreto.add(colori[r.nextInt(colori.length)]);
    }
  }

  void cambia(int pos) {
    setState(() {
      if (scelti[pos] == Colors.grey) {
        scelti[pos] = colori[0];
      } else {
        int index = colori.indexOf(scelti[pos]);
        if (index < colori.length - 1) {
          scelti[pos] = colori[index + 1];
        } else {
          scelti[pos] = colori[0];
        }
      }
    });
  }

  void controlla() {
    if (scelti.toString() == segreto.toString()) {
      print("Hai indovinato");
    } else {
      print("Errato");
    }

    // Ripristina la sequenza iniziale
    setState(() {
      scelti = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];
    });
  }

  // Codice visibile
  String mostraCodice(Color c) {
    if(c == Colors.red){
      return "🟥";
    }else if(c == Colors.green){
      return "🟩";
    }else if(c == Colors.blue){
      return "🟦";
    }
    return "🟨";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inferior Mind"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15, top: 15),
            child: Text(
              "${mostraCodice(segreto[0])} "
              "${mostraCodice(segreto[1])} "
              "${mostraCodice(segreto[2])} "
              "${mostraCodice(segreto[3])}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Indovina la sequenza di colori"),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () => cambia(i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scelti[i],
                      minimumSize: Size(60, 60),
                    ),
                    child: Text(""),
                  ),
                )
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: controlla,
            child: Text("Conferma"),
          )
        ],
      ),
    );
  }
}
