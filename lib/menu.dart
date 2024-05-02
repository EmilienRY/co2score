import 'package:flutter/material.dart';
import 'visuPlat.dart';
import 'database.dart';
import 'styles.dart';

class pageMenu extends StatefulWidget {
  @override
  _pageMenuState createState() => _pageMenuState();
}

class _pageMenuState extends State<pageMenu> {
  List<String> buttonTexts = []; // liste des plats

  @override
  void initState() { // on commence par charger touts les plats
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async { //fonction qui charge les plats depuis la BD et affecte à variable buttonTexts
    try {
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
    return MaterialApp(
      theme: AppStyles.themeData, //thème défini dans styles.dart
      home: Scaffold(
        appBar: AppBar(
          title: Text('Liste des plats'),
        ),

        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),

            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),

                      if (buttonTexts.isNotEmpty) // si on a des plats dans la bd
                        Column(

                          children: buttonTexts.map(
                                (text) => ListTile(
                              title: Text(text),
                                  trailing: IconButton(
                                icon: Icon(Icons.delete),  // bouton pour sup le plat de la bd
                                onPressed: () {
                                  _deletePlat(text);
                                },
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => pageVisu(recette: text), // bouton qui permet d'aller vers page pour visualiser les infos du plat
                                  ),
                                );
                              },

                            ),
                          ).toList(),

                        ),
                      if (buttonTexts.isEmpty) // si pas de plats on affiche msg
                        Text(
                          'ajoutez des plats pour les voir apparaitre ici', style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deletePlat(String nomPlat) async { // fonction pour supprimer un plat de la BD
    try {
      await DatabaseHelper.instance.deletePlat(nomPlat);
      _loadData();
    } catch (e) {
      print('Erreur lors de la suppression du plat: $e');
    }
  }
}
