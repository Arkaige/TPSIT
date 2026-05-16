import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'prodotto_notifier.dart';

// =============================================================================
// PAGINA PRINCIPALE - Scaffold con AppBar, Drawer, FAB e corpo a griglia
// =============================================================================

class PaginaPrincipale extends StatefulWidget {
  const PaginaPrincipale({super.key});

  @override
  State<PaginaPrincipale> createState() => _PaginaPrincipaleState();
}

class _PaginaPrincipaleState extends State<PaginaPrincipale> {
  bool temaScuro = false;

  void alternaTema() {
    setState(() {
      temaScuro = !temaScuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ProdottoNotifier>();
    bool usaCache = notifier.usaCache;

    return MaterialApp(
      title: 'Shop List',
      themeMode: temaScuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shop List'),
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.sincronizzaConServer(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Badge(
                label: Text('${notifier.contaProdotti}'),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Banner di cache quando server non raggiungibile
            if (usaCache)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Server non è raggiungibile, applicazione in cache',
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ],
                ),
              ),
            // Tab bar per categorie
            DefaultTabController(
              length: ProdottoNotifier.categorie.length,
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: TabBar(
                  isScrollable: true,
                  tabs: ProdottoNotifier.categorie.map((categoria) {
                    return Tab(text: categoria);
                  }).toList(),
                  onTap: (i) => notifier.cambiaCategoriaIndice(i),
                ),
              ),
            ),
            // Griglia prodotti
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: notifier.contaProdotti,
                itemBuilder: (context, index) {
                  final prodotto = notifier.prodottiFiltrati[index];
                  return CardProdotto(
                    prodotto: prodotto,
                    onRemove: () => notifier.rimuoviProdotto(prodotto.id),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _mostraDialogAggiungiProdotto(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _mostraDialogAggiungiProdotto(BuildContext context) {
    final notifier = context.read<ProdottoNotifier>();
    String nomeNuovo = '';
    double prezzoNuovo = 0.0;
    int quantitaNuova = 0;
    String categoriaNuova = 'Elettronica';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Aggiungi Nuovo Prodotto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (valore) => nomeNuovo = valore,
                  decoration: const InputDecoration(hintText: 'Nome prodotto'),
                  autofocus: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (valore) {
                    if (valore.isNotEmpty) {
                      prezzoNuovo = double.tryParse(valore) ?? 0.0;
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Prezzo'),
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (valore) {
                    if (valore.isNotEmpty) {
                      quantitaNuova = int.tryParse(valore) ?? 0;
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Quantità'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: categoriaNuova,
                  items: const [
                    DropdownMenuItem(
                      value: "Elettronica",
                      child: Text("Elettronica"),
                    ),
                    DropdownMenuItem(
                      value: "Abbigliamento",
                      child: Text("Abbigliamento"),
                    ),
                    DropdownMenuItem(value: "Casa", child: Text("Casa")),
                    DropdownMenuItem(value: "Sport", child: Text("Sport")),
                  ],
                  onChanged: (valore) {
                    if (valore != null) categoriaNuova = valore;
                  },
                  decoration: const InputDecoration(hintText: 'Categoria'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                if (nomeNuovo.isNotEmpty) {
                  notifier.aggiungiProdotto(
                    nomeNuovo,
                    prezzoNuovo,
                    quantitaNuova,
                    categoriaNuova,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }
}

// =============================================================================
// CARD PRODOTTO - Card con icona categoria e pulsante X per rimuovere
// =============================================================================

class CardProdotto extends StatefulWidget {
  final Prodotto prodotto;
  final VoidCallback onRemove;

  const CardProdotto({
    super.key,
    required this.prodotto,
    required this.onRemove,
  });

  @override
  State<CardProdotto> createState() => _CardProdottoState();
}

class _CardProdottoState extends State<CardProdotto> {
  bool espanso = false;

  void alternaEspansione() {
    setState(() {
      espanso = !espanso;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con icona categoria e pulsante rimuovi
          Stack(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: _coloreCategoria(widget.prodotto.categoria),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(
                    _iconaCategoria(widget.prodotto.categoria),
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: widget.onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          // Info prodotto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.prodotto.nome,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '€ ${widget.prodotto.prezzo.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.prodotto.categoria,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _coloreCategoria(String categoria) {
    switch (categoria) {
      case 'Elettronica':
        return Colors.blue;
      case 'Abbigliamento':
        return Colors.purple;
      case 'Casa':
        return Colors.orange;
      case 'Sport':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _iconaCategoria(String categoria) {
    switch (categoria) {
      case 'Elettronica':
        return Icons.devices;
      case 'Abbigliamento':
        return Icons.checkroom;
      case 'Casa':
        return Icons.home;
      case 'Sport':
        return Icons.sports_gymnastics;
      default:
        return Icons.category;
    }
  }
}
