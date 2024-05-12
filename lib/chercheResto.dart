import 'package:flutter/material.dart';
import 'dataBaseServ.dart';
import 'visuServ.dart';

class chercheResto extends StatefulWidget {

  @override
  _chercheRestoState createState() => _chercheRestoState();
}

class _chercheRestoState extends State<chercheResto> {
  final TextEditingController _controllerNomResto = TextEditingController(); //controlleur du textField
  List<PlatInfo> plats = []; //liste des plats pour le resto selectionné


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chercher les plats \n pour un établissement'),
      ),
      body: Center(
        child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),

              TextField(
                controller: _controllerNomResto,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nom de l'établissement",
                ),
              ),
              SizedBox(
                height: 25.0,
              ),


              ElevatedButton(
                onPressed: () async {   // appel de la fonction RecupPlatsResto pour avoir touts les plats du resto choisit
                  dataBaseServ db=dataBaseServ();
                  List<PlatInfo> result = await db.RecupPlatsResto(_controllerNomResto.text);

                  setState (() {
                  plats= result; // on affecte de résultat à plats
                });
                },
                child: Text('Chercher les plats'),
              ),
              SizedBox(
                height: 16.0,
              ),



              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),

                        if (plats.isNotEmpty) // on verif qu'on a bien recup des plats
                          Column(
                            children: plats.map(
                                  (plat) => ListTile(  // ajout d'un bouton pour chaques plats
                                title: Text(plat.nom),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => visuServ(plat: recupPlatInfo(plat.nom)), // bouton redirige vers visuServ avec comme param les info du plat
                                    ),
                                  );
                                },

                              ),
                            ).toList(),

                          ),
                        if (plats.isEmpty) // si pas de plat on affiche un msg ( si pas de plat soit on a pas encore cherché soit on a retourné un null)
                          Text(
                            'cherchez un établissement pour voir ses plats', style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),
                ),
              ),

            ]
        ),
      ),
    );
  }

  PlatInfo? recupPlatInfo(String nom){ // fonction pour recup le PlatInfo correspond au nom passé en paramètre
    for(int i=0;i<plats.length;i++){
      if( plats[i].nom==nom){
        return plats[i];
      }
    }

    return null;
  }



}