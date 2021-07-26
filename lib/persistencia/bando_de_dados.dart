import 'package:sqflite/sqflite.dart';

class BancoDeDados {
  static BancoDeDados? _instance;
  Database? db;
  final String nomeDB = "galeriadefotos.db";
  final String onCreateSQL = """
  CREATE TABLE fotos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT,
    descricao TEXT,
    data DATE,
    longitude REAL,
    latitude REAL,
    imagem TEXT
  );
  """;

  BancoDeDados._();

  factory BancoDeDados() {
    return _instance ??= BancoDeDados._();
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute(onCreateSQL);
  }

  Future<void> abrir() async {
    if (db != null) return;

    String caminho = await getDatabasesPath() + nomeDB;
    db = await openDatabase(caminho, version: 1, onCreate: onCreate);
  }
}
