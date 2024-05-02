import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatInfo { // classe pour simplifier le passage de paramètre pour les plats
  final String nom;
  final String ingredients;
  final String couleur;
  final String prix;

  PlatInfo(this.nom,this.ingredients, this.couleur, this.prix);
}

class dataBaseServ {  // opération de communication avec le serveur et sa base de donné


  void envoyerResto(Map<String, dynamic> resto) async { // envoie des infos d'un resto au serveur
    // Définis l'URL de ton serveur
    var url = Uri.parse('http://192.168.50.113:8080/ajouter_resto'); // l'adresse doit être changé suivant ou est lancé serveur

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


  void envoyerPlatResto(Map<String, List<PlatInfo>> val) async { // envoie des infos des plats associés à un resto
    // Définis l'URL de ton serveur
    var url = Uri.parse('http://192.168.50.113:8080/ajouterPlats');

    Map<String, List<List<String>>> aEnv={};
    List<List<String>> LesP=[];
    val.forEach((nomRestaurant, plats) { //  on formate au bon format pour envoyer
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

    // Envoie la requête post au serveur
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

  Future<List<PlatInfo>> RecupPlatsResto(String nomResto) async { // pour récup tout les plats d'un resto
    var url = Uri.parse('http://192.168.50.113:8080/plats/$nomResto'); // on passe nomResto à la fin de l'url
    try {
      var response = await http.get(url); // requète get

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // les données sont en json quand on les recois il faut les reconvertir

        List<PlatInfo> _plats = List<PlatInfo>.from(data.map((plat) => PlatInfo( plat['nom'], plat['ingredients'], plat['couleur'], plat['prix'])));
        return _plats;
      }
      else{
        print('Erreur lors de la récupération des plats else : ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la récupération des plats catch : $e');
      return [];
    }
  }

}
