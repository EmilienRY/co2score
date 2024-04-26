import 'dart:convert';
import 'package:http/http.dart' as http;

class dataBaseServ {

  // nom des tables et colonnes
  static final tablePlats = 'plat';
  static final tableresto = 'resto';
  static final tablepropose = 'propose';

  static final columnValeur = 'valeur';
  static final columnPrix = 'prix';
  static final columnNom = 'nom';
  static final columnNomResto = 'nomResto';
  static final columnAdresse = 'adresse';
  static final columnCouleur = 'couleur';
  static final columnIngredients = 'ingredients';


  // Méthode pour insérer un plat sur le serveur
  Future<int> insertPlat(Map<String, dynamic> plat) async {
    // URL de votre serveur où envoyer les données
    String url = 'http://192.168.113.113:8080/api/insertPlat';

    // Envoi de la requête POST avec les données du plat
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(plat), // Conversion du plat en JSON
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Vérification de la réponse du serveur
    if (response.statusCode == 200) {
      // Si la requête est réussie, vous pouvez traiter la réponse
      // Par exemple, si le serveur renvoie l'ID du plat inséré :
      return int.parse(response.body);
    } else {
      // Si la requête a échoué, vous pouvez gérer l'erreur ici
      throw Exception('Failed to insert plat');
    }
  }
}
