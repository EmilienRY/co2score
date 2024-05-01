import 'package:flutter/material.dart';
import 'dataBaseServ.dart';



class ajouterResto extends StatefulWidget {

  @override
  _ajouterRestoState createState() => _ajouterRestoState();
}

class _ajouterRestoState extends State<ajouterResto> {
  final TextEditingController _controllerNomResto = TextEditingController();
  final TextEditingController _controllerAdresse = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ajouter un établissement'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _controllerNomResto,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nom de l'établissement",
              ),
            ),
            TextField(
              controller: _controllerAdresse,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nom de l'établissement",
              ),
            ),


            ElevatedButton(
              onPressed: () async {
                // Vérifier si au moins un champ est vide
                bool fieldsEmpty = _controllerNomResto.text.isEmpty || _controllerAdresse.text.isEmpty;

                // Afficher un avertissement si au moins un champ est vide
                if (fieldsEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Champs vides"),
                        content: Text("Veuillez remplir tous les champs."),
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
                  final resto = {
                    'nom': _controllerNomResto.text,
                    'adresse': _controllerAdresse.text, // Correction de la clé
                  };


                  try {
                    dataBaseServ db=dataBaseServ();
                    db.envoyerResto(resto);

                    _controllerNomResto.clear();
                    _controllerAdresse.clear();

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


          ],
        ),

      ),
    );
  }
}