import 'package:flutter/material.dart';
import 'dataBaseServ.dart';
import 'database.dart';


class ajoutPlatResto extends StatefulWidget {

  @override
  _ajoutPlatRestoState createState() => _ajoutPlatRestoState();
}

class _ajoutPlatRestoState extends State<ajoutPlatResto> {
  final TextEditingController _controllerNomEta = TextEditingController(); // controlleur du textfield
  List<PlatInfo> selectedPlats = []; // liste des plats que l'on veut envoyer
  List<String> plats = []; // liste des plats que l'on possède localement

  @override
  void initState() {
    super.initState();
    fetchPlatsFromDatabase();  // appel de la fonction pour recup tout les plats
  }

  Future<void> fetchPlatsFromDatabase() async {   //pour recup tout les plats
    try {
      final dbHelper = DatabaseHelper.instance;
      final platsList = await dbHelper.queryAllPlats();
      setState(() {
        plats = platsList.map((plat) => plat['nom'] as String).toList(); // met les plats dans la variable plats
      });
    } catch (e) {
      print("Erreur lors de la récupération des plats depuis la base de données : $e"); //affiche ca si erreur
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ajouter des plats à un établissement',style: TextStyle(fontSize: 16.0),),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 8.0,
            ),


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

                  String nomResto= _controllerNomEta.text;  // recup du resto

                  final Map<String, List<PlatInfo>> val = {}; // on met les plats dans un dictionnaire
                  val[nomResto] = selectedPlats;


                  try {
                    dataBaseServ db=dataBaseServ();  // appel de la fonction de dataBaseServ envoyerPlatResto
                    db.envoyerPlatResto(val);



                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Bien ajouté"),
                          content: Text("Les plats ont bien été ajouté à l'établissement"),
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
              child: const Text('Ajouter'),
            ),

            SizedBox(
              height: 16.0,
            ),



            TextField(
                  controller: _controllerNomEta,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom de l'établissement",
                  ),
                ),

            SizedBox(
              height: 16.0,
            ),

            Text(
              "Choisissez les plats à ajouter à l'établissement :",
            ),

            SizedBox(
              height: 16.0,
            ),


            Expanded(
              child: ListView.builder( // affiche la liste de tout les plats que l'on a dans notre appli
                itemCount: plats.length,
                itemBuilder: (BuildContext context, int index) {
                  final plat = plats[index];
                  return CheckboxListTile(
                    title: Text(plat),
                    value: selectedPlats.any((element) => element.nom == plat),
                    onChanged: (bool? value){  // ajoute a selectedPlat si on clique sur la checkbox du plat
                      setState(() {
                        if (value != null && value) {
                          addPlat(plat);
                        } else {
                          removePlat(plat);
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


  Future<void> addPlat(String Nomplat) async { // fonction qui ajoute un plat selectionné avec checkbox à selectedPlat
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(Nomplat);
    if (plat != null) {
      setState(() {
        selectedPlats.add(PlatInfo(plat['nom'],plat['ingredients'], plat['couleur'], plat['prix'])); // ajoute sous la forme d'un PlatInfo pour pouvoir plus facilement recup les valeurs
      });
    }

  }

//enlève le plat de selectedPlats
  void removePlat(String plat) {
    setState(() {
      selectedPlats.removeWhere((element) => element.nom == plat);
    });
  }

}