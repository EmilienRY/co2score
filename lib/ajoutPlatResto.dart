import 'package:flutter/material.dart';
import 'dataBaseServ.dart';
import 'database.dart';




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

            ElevatedButton(
              onPressed: () async {
                // Vérifier si au moins un champ est vide
                bool fieldsEmpty = _controllerNomEta.text.isEmpty || selectedPlats.isEmpty;

                // Afficher un avertissement si au moins un champ est vide
                if (fieldsEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Champs vides"),
                        content: Text("Veuillez donner le nom de l'établissement et sélectionner au moins un plat."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                else{

                  String nomResto= _controllerNomEta.text;

                  final Map<String, List<PlatInfo>> val = {};
                  val[nomResto] = selectedPlats;


                  try {
                    dataBaseServ db=dataBaseServ();
                    db.envoyerPlatResto(val);



                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Bien ajouté"),
                          content: Text("L'ingrédient a bien été ajouté dans la base de donné"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                  } catch (e) {
                    print("Erreur lors de l'insertion");
                  }


                }

              },
              child: const Text('Valider plat'),
            ),


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





  Future<void> addPlat(String Nomplat) async {
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(Nomplat);
    if (plat != null) {
      setState(() {
        selectedPlats.add(PlatInfo(plat['nom'],plat['ingredients'], plat['couleur'], plat['prix']));
      });
    }

  }

// Définir une fonction pour retirer un plat de selectedPlats
  void removePlat(String plat) {
    setState(() {
      selectedPlats.removeWhere((element) => element.nom == plat);
    });
  }

}