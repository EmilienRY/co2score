import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:io';


class DatabaseHelper {   // classe avec fonctions pour gérer la base de donnée

  static final _databaseName = 'donne.db';
  static final _databaseVersion = 1;

  // nom des tables et colonnes
  static final tablePlats = 'plat';
  static final tableIngr = 'ingredient';
  static final columnValeur = 'valeur';
  static final columnPrix = 'prix';
  static final columnNom = 'nom';
  static final columnCouleur = 'couleur';
  static final columnIngredients = 'ingredients';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();


  Future<void> initializeDatabase() async {  // fonction pour initialiser la base de donné si elle n'existe pas

    String databasesPath = await getDatabasesPath(); // chemin vers la ou on stocke la bd
    String path = join(databasesPath, _databaseName);


    bool exists = await databaseExists(path);    // on verif si la bd existe déjà

    if (!exists) {   // Si la bd n'existe pas on copie depuis les assets
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      print("bd créée");
      await File(path).writeAsBytes(bytes);
    }
    else {
      print("bd exite déjà");   // si jamais existe déjà
    }
  }


  static Database? _database;  // db qu'on utilise dans les fonctions

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ouvrir bd pour pouvoir l'utiliser
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, _databaseName);
    return await openDatabase(databasePath,
        version: _databaseVersion);
  }


  //  ----------------------Opérations pour les plats-----------------------

  Future<int> insertPlat(Map<String, dynamic> plat) async {   // rajout d'un plat
    Database db = await instance.database;
    return await db.insert(tablePlats, plat);
  }

  Future<List<Map<String, dynamic>>> queryAllPlats() async {   // pour recup tout les plats de la bd
    Database db = await instance.database;
    final plats=await db.query(tablePlats);
    return plats;
  }

  Future<int> deletePlat(String nomPlat) async {   // supp du plat
    Database db = await instance.database;
    return await db.delete(tablePlats, where: '$columnNom = ?', whereArgs: [nomPlat]);
  }


  Future<Map<String, dynamic>?> getPlat(String nomPlat) async {   // recup du plat avec son nom
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

  // ---------------------- opérations sur les ingrédients -------------------------------

  Future<List<Map<String, dynamic>>> queryAllIngredients() async {   // pour recup tout les ingrédients de la bd
    Database db = await instance.database;
    final ingrs=await db.query(tableIngr);
    print(ingrs);
    return ingrs;
  }


  Future<int> insertIngredient(Map<String, dynamic> ingre) async {   // rajout d'un ingrédient
    Database db = await instance.database;
    return await db.insert(tableIngr, ingre);
  }


  Future<Map<String, dynamic>?> getIngredient(String nomIngr) async {   // recup de l'ingredient avec son nom
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableIngr,
      where: '$columnNom = ?',
      whereArgs: [nomIngr],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    else {
      return null; //  null si aucun ingredient avec ce nom est trouvé
    }
  }


  Future<List<String>> getSimilarIngredients(String partialIngredient) async { // fonction utile dans la création du plat pour proposer à l'user les ingrédients similaire a ce qu'il écrit
    final Database db = await instance.database;
    final List<Map<String, dynamic>> ingredients = await db.rawQuery(
      'SELECT $columnNom FROM $tableIngr WHERE $columnNom LIKE ?',    // on utilise une requète LIKE pour recup les similaires
      ['%$partialIngredient%'],
    );

    List<String> ingre=List<String>.generate(ingredients.length, (int index) => ingredients[index][columnNom]);
    ingre.sort((a, b) => a.length.compareTo(b.length));

    return ingre; // on recup les ingrédients sous forme de liste de string
  }

  Future<List<String>> getVide() async { // pour recup une liste vide, utile dans création plat lorsque user n'a encore rien saisie ou que un espace
    List<String> ingre=[];
    return ingre;
  }

}