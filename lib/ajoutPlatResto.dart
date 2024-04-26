import 'package:flutter/material.dart';
import 'database.dart';

class PlatInfo {
  final String nom;
  final Color couleur;
  final String prix;

  PlatInfo(this.nom, this.couleur, this.prix);
}

class IngredientRow {
  TextEditingController controllerIngredient = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
}

class ajoutPlatResto extends StatefulWidget {

  @override
  _ajoutPlatRestoState createState() => _ajoutPlatRestoState();
}

class _ajoutPlatRestoState extends State<ajoutPlatResto> {
  final TextEditingController _controllerNomEta = TextEditingController();
  List<PlatInfo> selectedPlats = [];
  List<String> plats = [];

  @override
  void initState() {
    super.initState();
    fetchPlatsFromDatabase();
  }

  Future<void> fetchPlatsFromDatabase() async {   //pour recup tout les plats et les afficher
    try {
      final dbHelper = DatabaseHelper.instance;
      final platsList = await dbHelper.queryAllPlats();
      setState(() {
        plats = platsList.map((plat) => plat['nom'] as String).toList();
      });
    } catch (e) {
      print("Erreur lors de la récupération des plats depuis la base de données : $e"); //affiche ca si erreur
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ajouter des plats à un établissement'),
      ),
      body: Center(
        child: Column(
          children: [



            TextField(
                  controller: _controllerNomEta,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom de l'établissement",
                  ),
                ),


            Text(
              "Choisissez les plats à ajouter à l'établissement :",
            ),

            Expanded(
              child: ListView.builder(
                itemCount: plats.length,
                itemBuilder: (BuildContext context, int index) {
                  final plat = plats[index];
                  return CheckboxListTile(
                    title: Text(plat),
                    value: selectedPlats.any((element) => element.nom == plat),
                    onChanged: (bool? value){
                      setState(() {
                        if (value != null && value) {
                          addPlat(plat);
                          //selectedPlats.add(PlatInfo(plat, await _getPlatColor(plat), await _getPlatPrice(plat)));
                        } else {
                          removePlat(plat);
                          //selectedPlats.removeWhere((element) => element.nom == plat);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),

      ),
    );
  }


  Future<Color?> _parseColor(String colorString) async {   // on recup couleurs (type PdfColor pour mettre dans pdf)
    switch (colorString.toLowerCase().replaceAll(' ', '')) {
      case 'rouge':
        return Colors.red;
      case 'vert':
        return Colors.green;
      case 'vertf':
        return Color.fromRGBO(12, 126, 12, 1.0);
      case 'orange':
        return Color.fromRGBO(206, 125, 2, 1.0);
      case 'jaune':
        return Color.fromRGBO(153, 153, 0, 1);
      default:
        return null;
    }
  }




  Future<Color> _getPlatColor(String platName) async {  // fonction pour recup couleur du plat dans base de donnée
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(platName);
    if (plat != null) {
      final colorString = plat['couleur'] as String;
      final color = await _parseColor(colorString);
      if (color != null) {
        return color;
      }
    }

    return Colors.black;  // si problème pour trouver couleur met du gris
  }


  Future<String> _getPlatPrice(String platName) async { // pour recup le prix du plat
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(platName);
    if (plat != null) {
      return plat['prix'] as String;
    }
    return '';
  }

  Future<void> addPlat(String plat) async {
    var couleur = await _getPlatColor(plat);
    var prix = await _getPlatPrice(plat);
    setState(() {
      selectedPlats.add(PlatInfo(plat, couleur, prix));
    });
  }

// Définir une fonction pour retirer un plat de selectedPlats
  void removePlat(String plat) {
    setState(() {
      selectedPlats.removeWhere((element) => element.nom == plat);
    });
  }

}