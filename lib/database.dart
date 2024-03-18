import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'plat.db';
  static final _databaseVersion = 1;

  // Définir les noms de tables et les colonnes
  static final tablePlats = 'plat';
  static final columnNom = 'nom';
  static final columnCouleur = 'couleur';
  static final columnIngredients = 'ingredients';

  // Faire en sorte que la classe soit un singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// test si elle existe
  Future<bool> isDatabaseExists() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await databaseExists(path);
  }

  //crée la base de donné
  Future<void> createDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    final db = await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute('''
        CREATE TABLE $tablePlats (
          $columnNom TEXT NOT NULL PRIMARY KEY,
          $columnCouleur TEXT NOT NULL,
          $columnIngredients TEXT NOT NULL
        )
      ''');
        });
  }





  // Créer une instance de base de données SQLite
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialiser la base de données
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, _databaseName);
    return await openDatabase(databasePath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Créer la structure de la base de données si elle n'existe pas déjà
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePlats (
        $columnNom TEXT NOT NULL PRIMARY KEY,
        $columnCouleur TEXT NOT NULL,
        $columnIngredients TEXT NOT NULL
      )
    ''');
  }

  // Opérations CRUD pour les plats
  Future<int> insertPlat(Map<String, dynamic> plat) async {
    Database db = await instance.database;
    return await db.insert(tablePlats, plat);
  }

  Future<List<Map<String, dynamic>>> queryAllPlats() async {
    Database db = await instance.database;
    return await db.query(tablePlats);
  }


  Future<Map<String, dynamic>?> getPlat(String nomPlat) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tablePlats,
      where: '$columnNom = ?',
      whereArgs: [nomPlat],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null; // Retourner null si aucun plat avec ce nom n'est trouvé
    }
  }


// Ajouter d'autres méthodes CRUD selon vos besoins
}
