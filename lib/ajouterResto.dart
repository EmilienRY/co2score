import 'package:flutter/material.dart';
import 'dataBaseServ.dart';



class ajouterResto extends StatefulWidget {

  @override
  _ajouterRestoState createState() => _ajouterRestoState();
}

class _ajouterRestoState extends State<ajouterResto> {
  final TextEditingController _controllerNomResto = TextEditingController(); // controlleur pour les textfield
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
            SizedBox(
              height: 8.0,
            ),

            TextField(
              controller: _controllerNomResto,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nom de l'établissement",
              ),
            ),
            SizedBox(
              height: 8.0,
            ),

            TextField(
              controller: _controllerAdresse,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "adresse",
              ),
            ),
            SizedBox(
              height: 16.0,
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
                  final resto = { // recup des infos sur le resto
                    'nom': _controllerNomResto.text,
                    'adresse': _controllerAdresse.text,
                  };


                  try {
                    dataBaseServ db=dataBaseServ(); //on appel la fonction envoyerResto de la classe dataBaseServ
                    db.envoyerResto(resto);

                    _controllerNomResto.clear(); //vide les texts fields une fois envoyé
                    _controllerAdresse.clear();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {  // affiche un message quand ajouté
                        return AlertDialog(
                          title: Text("Bien ajouté"),
                          content: Text("L'établissement a bien été envoyé"),
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