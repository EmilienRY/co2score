import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chercheResto.dart';
import 'ajouterResto.dart';
import 'ajoutPlatResto.dart';

class pageCom extends StatefulWidget {  // page ou on test si serveur en ligne
  @override
  _pageComState createState() => _pageComState();
}

class _pageComState extends State {
  bool estConnecte = false; // false de base

  @override
  void initState() {
    super.initState();
    verifierConnexion();
  }

  Future<void> verifierConnexion() async { // fonction qui vérifie si serveur en ligne
    try {
      var response = await http.get(Uri.parse('http://192.168.50.113:8080'));
      // Vérifiez le code de statut de la réponse
      if (response.statusCode == 200) {
        setState(() {
          estConnecte = true;  // si il est en ligne alors estConnecte passe à true
        });
      } else {
        setState(() {
          estConnecte = false; // si il n'est pas en ligne alors estConnecte passe à false ( cas ou le serveur était en ligne au début utilisation appli puis arrète)
        });
      }
    } catch (e) {
      setState(() {
        estConnecte = false; // cas ou il y a une erreur on met à false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: estConnecte
            ? Scaffold(  // on arrive à se co au serv et on met les boutons vers pages pour intéragir avec
              body: Center(
                  child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Text("Que souhaitez vous faire :"),
                        const SizedBox(height: 30),
                        TextButton(
                          child: Text("chercher un établissement"),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => chercheResto(),
                              ),
                            );

                          },
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          child: Text("ajouter un établissement "),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ajouterResto(),
                              ),
                            );

                          },
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          child: Text("ajouter des plats à un établissement "),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ajoutPlatResto(),
                              ),
                            );

                          },
                        ),

                      ]
                  )
              )
            )

            : Center (child : Text('Non connecté au serveur'),) // cas ou l'on arrive pas à se co au serv

    );
  }
}


