import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatInfo {
  final String nom;
  final String ingredients;
  final String couleur;
  final String prix;

  PlatInfo(this.nom,this.ingredients, this.couleur, this.prix);
}

class dataBaseServ {


  void envoyerResto(Map<String, dynamic> resto) async {
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


  void envoyerPlatResto(Map<String, List<PlatInfo>> val) async {
    // Définis l'URL de ton serveur
    var url = Uri.parse('http://192.168.113.113:8080/ajouterPlats');

    Map<String, List<List<String>>> aEnv={};
    List<List<String>> LesP=[];
    val.forEach((nomRestaurant, plats) {
      plats.forEach((plat) {
        List<String> a=[];
        a.add(plat.nom);
        a.add(plat.ingredients);
        a.add(plat.couleur);
        a.add(plat.prix);
        LesP.add(a);
      });
      aEnv[nomRestaurant]=LesP;
    });

      // Convertis les données en format JSON
    var body = jsonEncode(aEnv);

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
