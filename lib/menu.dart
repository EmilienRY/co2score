import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'CreationPlat.dart';
import 'visuPlat.dart';
import 'database.dart';
import 'creationEtiquette.dart';

class pageMenu extends StatefulWidget {
  @override
  _pageMenuState createState() => _pageMenuState();
}

class _pageMenuState extends State<pageMenu> {
  List<String> buttonTexts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Récupérer les noms des plats depuis la base de données
      final plats = await DatabaseHelper.instance.queryAllPlats();
      setState(() {
        buttonTexts = plats.map<String>((plat) => plat['nom'] as String).toList();
      });
    } catch (e) {
      print('Erreur lors du chargement des données depuis la base de données: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page des menus'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pageCreation()),
                );
              },
              child: Text('Ajouter un plat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneratePdfPage()),
                );
              },
              child: Text('créer une étiquette'),
            ),
            SizedBox(height: 20),
            Text(
              'Contenu sous le bouton',
              style: TextStyle(fontSize: 18),
            ),
            if (buttonTexts.isNotEmpty)
              Column(
                children: buttonTexts.map(
                      (text) => ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pageVisu(recette: text),
                        ),
                      );
                    },
                    child: Text(text),
                  ),
                ).toList(),
              ),
            if (buttonTexts.isEmpty)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
