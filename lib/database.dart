import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:io';


class DatabaseHelper {   // classe avec fonctions pour gérer la base de donnée

  static final _databaseName = 'donne.db';
  static final _databaseVersion = 1;

  // nom des tables et colonnes
  static final tablePlats = 'plat';
  static final columnNom = 'nom';
  static final columnCouleur = 'couleur';
  static final columnIngredients = 'ingredients';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();


  Future<void> initializeDatabase() async {  // fonction pour initialiser la base de donné si elle n'existe pas

    String databasesPath = await getDatabasesPath(); // chemin vers la ou on stocke la bd
    String path = join(databasesPath, _databaseName);


    bool exists = await databaseExists(path);    // on verif si la bd existe déjà

    if (!exists) {   // Si la bd n'existe pason copie depuis les assets
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
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
    return await db.query(tablePlats);
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


}
