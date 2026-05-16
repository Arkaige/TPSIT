import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prodotto_notifier.dart';
import 'widgets.dart'; // Contiene PaginaPrincipale e tutti i widget UI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop List',
      themeMode: ThemeMode.light, // Tema chiaro di default
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => ProdottoNotifier(),
        child: PaginaPrincipale(),
      ),
    );
  }
}
