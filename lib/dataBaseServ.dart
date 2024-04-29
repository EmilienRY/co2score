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


  void envoyerDonneesAuServeur(Map<String, dynamic> resto) async {
    // Définis l'URL de ton serveur
    var url = Uri.parse('http://192.168.113.113:8080/ajouter_resto');

    // Convertis les données en format JSON
    var body = jsonEncode(resto);

    // Envoie la requête POST au serveur
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    // Vérifie la réponse du serveur
    if (response.statusCode == 200) {
      print('Données envoyées avec succès');
    } else {
      print('Erreur lors de l\'envoi des données : ${response.statusCode}');
    }
  }






}
