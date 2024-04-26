import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class pageCom extends StatefulWidget {
  @override
  _pageComState createState() => _pageComState();
}

class _pageComState extends State


{
  bool estConnecte = false;

  @override
  void initState() {
    super.initState();
    verifierConnexion();
  }

  Future<void> verifierConnexion() async {
    try {
      print("j'essaye de me co");
      var response = await http.get(Uri.parse('http://192.168.1.39:8080'));
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
      body: Center(
        child: estConnecte
            ? Text('Connecté au serveur')
            : Text('Non connecté au serveur'),
      ),
    );
  }
}


