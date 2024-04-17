import 'package:flutter/material.dart';
import 'CreationPlat.dart';
import 'visuPlat.dart';
import 'database.dart';
import 'creationEtiquette.dart';
import 'styles.dart';
import 'main.dart';

class pageMenu extends StatefulWidget {
  @override
  _pageMenuState createState() => _pageMenuState();
}

class _pageMenuState extends State<pageMenu> {
  List<String> buttonTexts = [];

  PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('page des menus'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pageCreation()),
                    );
                    _loadData();
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
                  child: Text('Créer une étiquette'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Liste des plats',
                      style: TextStyle(fontSize: 18),
                    ),
                    if (buttonTexts.isNotEmpty)
                      Column(
                        children: buttonTexts.map(
                              (text) => ListTile(
                            title: Text(text),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deletePlat(text);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => pageVisu(recette: text),
                                ),
                              );
                            },
                          ),
                        ).toList(),
                      ),
                    if (buttonTexts.isEmpty)
                      Text(
                        'ajoutez des plats pour les voir apparaitre ici', style: TextStyle(fontSize: 18),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }



  void _deletePlat(String nomPlat) async {
    try {
      await DatabaseHelper.instance.deletePlat(nomPlat);
      _loadData();
    } catch (e) {
      print('Erreur lors de la suppression du plat: $e');
    }
  }


}
