import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inizializzaDatabase();
    return _database!;
  }

  static Future<Database> _inizializzaDatabase() async {
    String path = join(await getDatabasesPath(), 'ecommerce.db');
    print("CREATE DB");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _creaTabellaProdotti,
    );
  }

  static Future<void> _creaTabellaProdotti(Database db, int version) async {
    print("CREATE TABLES");

    await db.execute('''
    CREATE TABLE prodotti (
      id TEXT PRIMARY KEY,
      nome TEXT,
      prezzo REAL,
      quantitaDisponibile INTEGER DEFAULT 0,
      categoria TEXT
    )
  ''');
  }

  static Future<List<Prodotto>> ottieneTuttiProdotti() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('prodotti');
    if (result.isEmpty) {
      return <Prodotto>[];
    }
    return result.map((row) => Prodotto.fromJson(row)).toList();
  }

  static Future<void> inserisciProdotto(Prodotto prodotto) async {
    final db = await database;
    await db.insert('prodotti', prodotto.toJson());
  }

  static Future<void> aggiornaProdotto(Prodotto prodotto) async {
    final db = await database;
    await db.update(
      'prodotti',
      prodotto.toJson(),
      where: 'id = ?',
      whereArgs: [prodotto.id],
    );
  }

  static Future<void> eliminaProdotto(String id) async {
    final db = await database;
    await db.delete('prodotti', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> prodottoEsiste(String id) async {
    final db = await database;
    var tables = await db.query('prodotti', where: 'id = ?', whereArgs: [id]);

    if (tables.isEmpty) {
      return false;
    }

    return true;
  }
}
