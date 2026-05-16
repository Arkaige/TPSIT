import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'database_helper.dart';

class ProdottoNotifier with ChangeNotifier {
  List<Prodotto> listaProdotti = [];
  bool staCaricando = false;
  bool serverRaggiungibile = true;

  // Categorie disponibili per il filtro a tab
  static const List<String> categorie = [
    "Tutti",
    "Elettronica",
    "Abbigliamento",
    "Casa",
    "Sport",
  ];

  String categoriaSelezionata = "Tutti";

  bool get usaCache => !serverRaggiungibile;
  int get contaProdotti => prodottiFiltrati.length;

  // Restituisce i prodotti filtrati per categoria selezionata
  List<Prodotto> get prodottiFiltrati {
    if (categoriaSelezionata == "Tutti") {
      return listaProdotti;
    }
    return listaProdotti
        .where((p) => p.categoria == categoriaSelezionata)
        .toList();
  }

  ProdottoNotifier() {
    init();
  }

  void init() async {
    await sincronizzaConServer();
  }

  void cambiaCategoriaIndice(int indice) {
    if (indice >= 0 && indice < categorie.length) {
      categoriaSelezionata = categorie[indice];
      notifyListeners();
    }
  }

  Future<void> aggiungiProdotto(
    String nome,
    double prezzo,
    int quantita,
    String categoria,
  ) async {
    try {
      Prodotto nuovoProdotto = await creaSuServer(
        "",
        nome,
        prezzo,
        quantita,
        categoria,
      );
      listaProdotti.add(nuovoProdotto);
      await DatabaseHelper.inserisciProdotto(nuovoProdotto);
    } catch (e) {
      // Se il server non è raggiungibile, crea solo in cache
      if (!serverRaggiungibile) {
        String nuovoId = DateTime.now().millisecondsSinceEpoch.toString();
        Prodotto nuovoProdotto = Prodotto(
          id: nuovoId,
          nome: nome,
          prezzo: prezzo,
          quantitaDisponibile: quantita,
          categoria: categoria,
        );
        listaProdotti.add(nuovoProdotto);
        await DatabaseHelper.inserisciProdotto(nuovoProdotto);
      } else {
        rethrow;
      }
    }
    notifyListeners();
  }

  Future<void> rimuoviProdotto(String id) async {
    for (var i = 0; i < listaProdotti.length; i++) {
      if (listaProdotti[i].id == id) {
        listaProdotti.removeAt(i);
        break;
      }
    }

    try {
      await eliminaDaServer(id);
    } catch (e) {
      // Se il server non è raggiungibile, aggiorna solo la cache
      if (!serverRaggiungibile) {
        await DatabaseHelper.eliminaProdotto(id);
      } else {
        rethrow;
      }
    }

    notifyListeners();
  }

  Future<void> sincronizzaConServer() async {
    staCaricando = true;
    serverRaggiungibile = true;
    try {
      listaProdotti = await recuperaDaServer(http.Client());
      await sincronizzaDBConServer();
    } catch (e) {
      print("Errore connessione server: $e");
      serverRaggiungibile = false;
      listaProdotti = await DatabaseHelper.ottieneTuttiProdotti();
    } finally {
      staCaricando = false;
      notifyListeners();
    }
  }

  Future<void> sincronizzaDBConServer() async {
    if (!serverRaggiungibile) return;

    List<Prodotto> prodottiServer = await recuperaDaServer(http.Client());
    for (Prodotto p in prodottiServer) {
      bool prodottoEsiste = await DatabaseHelper.prodottoEsiste(p.id);
      if (!prodottoEsiste) {
        await DatabaseHelper.inserisciProdotto(p);
      }
    }
  }

  Future<Prodotto> creaSuServer(
    String id,
    String nome,
    double prezzo,
    int quantita,
    String categoria,
  ) async {
    final response = await http.post(
      Uri.parse("http://192.168.1.132:3000/prodotti"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        "id": id,
        "nome": nome,
        "prezzo": prezzo,
        "quantitaDisponibile": quantita,
        "categoria": categoria,
      }),
    );

    if (response.statusCode == 201) {
      return Prodotto.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to create prodotto.');
    }
  }

  Future<List<Prodotto>> recuperaDaServer(http.Client client) async {
    final response = await client
        .get(Uri.parse('http://192.168.1.132:3000/prodotti'))
        .timeout(Duration(seconds: 10));

    return analizzaProdotti(response.body);
  }

  List<Prodotto> analizzaProdotti(String responseBody) {
    final parsed = (jsonDecode(responseBody) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    return parsed.map<Prodotto>(Prodotto.fromJson).toList();
  }

  Future<bool> eliminaDaServer(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('http://192.168.1.132:3000/prodotti/$id'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete prodotto.');
    }
  }
}
