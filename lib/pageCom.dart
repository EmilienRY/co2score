import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chercheResto.dart';
import 'ajouterResto.dart';
import 'ajoutPlatResto.dart';

class pageCom extends StatefulWidget {
  @override
  _pageComState createState() => _pageComState();
}

class _pageComState extends State {
  bool estConnecte = false;
  final TextEditingController _controllerPrix = TextEditingController();

  @override
  void initState() {
    super.initState();
    verifierConnexion();
  }

  Future<void> verifierConnexion() async {
    try {
      print("j'essaye de me co");
      var response = await http.get(Uri.parse('http://192.168.113.113:8080'));
      print("yo");
      // Vérifiez le code de statut de la réponse
      if (response.statusCode == 200) {
        print("bien co");
        setState(() {
          estConnecte = true;
        });
      } else {
        print("pas co");
        setState(() {
          estConnecte = false;
        });
      }
    } catch (e) {
      print("erreur");
      setState(() {
        estConnecte = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statut de connexion'),
      ),
      body: estConnecte
            ? Scaffold(  // on arrive à se co au serv
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


