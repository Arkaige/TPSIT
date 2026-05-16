class Prodotto {
  String id;
  String nome;
  double prezzo;
  int quantitaDisponibile;
  String categoria;

  Prodotto({
    required this.id,
    required this.nome,
    required this.prezzo,
    this.quantitaDisponibile = 0,
    this.categoria = "Generale",
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "prezzo": prezzo,
      "quantitaDisponibile": quantitaDisponibile,
      "categoria": categoria,
    };
  }

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    return Prodotto(
      id: json["id"] as String,
      nome: json["nome"] as String,
      prezzo: (json["prezzo"] as num).toDouble(),
      quantitaDisponibile: json["quantitaDisponibile"] ?? 0,
      categoria: json["categoria"] ?? "Generale",
    );
  }

  @override
  String toString() {
    return 'Prodotto{id: $id, nome: $nome, prezzo: $prezzo, quantitaDisponibile: $quantitaDisponibile, categoria: $categoria}';
  }
}
