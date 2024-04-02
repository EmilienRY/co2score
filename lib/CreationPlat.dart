import 'package:flutter/material.dart';
import 'database.dart';
import 'menu.dart';

class IngredientRow {
  TextEditingController controllerIngredient = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
}

class pageCreation extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<pageCreation> {
  final TextEditingController _controllerNomPlat = TextEditingController();
  final TextEditingController _controllerPrix = TextEditingController();

  final List<IngredientRow> ListIngredient = [];

  void _supIngredient(int index) {
    setState(() {
      ListIngredient.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer votre plat'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: _controllerNomPlat,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nom du plat',
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controllerPrix,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Prix du plat',
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: ListIngredient.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            // Récupérer la liste des ingrédients similaires depuis la base de données
                            return DatabaseHelper.instance.getSimilarIngredients(textEditingValue.text);
                          },
                          onSelected: (String selectedIngredient) {
                            setState(() {
                              ListIngredient[index].controllerIngredient.text = selectedIngredient;   // Mettre à jour le texte de l'ingrédient dans la ligne en cours

                            });
                          },
                          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ingrédient',
                              ),
                            );
                          },
                          optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                child: Container(
                                  constraints: BoxConstraints(maxHeight: 200.0),
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(8.0),
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final String option = options.elementAt(index);
                                      return GestureDetector(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        child: ListTile(
                                          title: Text(option),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: ListIngredient[index].controllerQuantity,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Quantité',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _supIngredient(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ListIngredient.add(IngredientRow());
                });
              },
              child: const Text('Ajouter un ingrédient'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Vérifier si au moins un champ est vide
                bool fieldsEmpty = _controllerNomPlat.text.isEmpty ||
                    _controllerPrix.text.isEmpty ||
                    ListIngredient.any((row) =>
                    row.controllerIngredient.text.isEmpty ||
                        row.controllerQuantity.text.isEmpty);

                bool platExists = await DatabaseHelper.instance.getPlat(_controllerNomPlat.text) != null;  // verif si le nom du plat existe déjà dans la base de données


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
                // Afficher un avertissement si le nom du plat existe déjà dans la base de données
                else if (platExists) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Plat déjà existant"),
                        content: Text("Un plat avec ce nom existe déjà. Veuillez choisir un autre nom."),
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
                } else {
                  // Tous les champs sont remplis et le nom du plat n'existe pas dans la base de données

                  List<String> ingredientsList = [];
                  double finalCO2=0;
                  double quantitePlat=0;
                  for (IngredientRow row in ListIngredient) {
                    String ingredient = row.controllerIngredient.text;
                    double? quantity = double.tryParse(row.controllerQuantity.text.replaceAll(',', '.'));
                    if (quantity != null) {

                      Map<String, dynamic>? ingredientData = await DatabaseHelper.instance.getIngredient(ingredient);
                      if (ingredientData != null) {
                        double? value = ingredientData['valeur'];
                        if(value == null){
                          ingredientsList.add('$ingredient,noir');  // on met couleur noir si il y a eu une erreur pour signifier qu'il y a eu un problème
                        }
                        else{  // partie pour choisir la couleur de chaques ingrédients
                          double GparKG=value*1000;  // dans la BD la valeur est en KG de CO2 pour 1 KG de produit , on convertit en gramme de CO2 pour 1 kg de produit
                          double GparG=GparKG/10;  //  on ramène ça à gramme de CO2 pour 100 g de produit
                          double totalCO2 = quantity * (GparG/100);  // quantiré de CO2 émise par la quantité de produit mis dans le plat
                          quantitePlat+=quantity;  // on ajoute le masse de produit dans le total du plat
                          finalCO2+=totalCO2; // on ajoute l'émission de l'ingrédient au total d'émission du plat

                          String color;


                          // on détermine la couleur de l'ingrédient en fonction de l'émission de 100 g de produit
                          if (GparG < 150) {
                            color = 'Vert';
                          } else if (GparG > 450) {
                            color = 'Rouge';
                          } else {
                            color = 'Jaune';
                          }
                          // Ajouter l'ingrédient avec sa couleur au format "ingredient,Couleur;..."
                          ingredientsList.add('$ingredient,$color');
                        }

                      } else {
                        // Si aucune donnée sur l'ingrédient n'est trouvée dans la base de données, on suppose une couleur jaune
                        ingredientsList.add('$ingredient,Jaune');
                      }

                    }
                  }

                  String ingredients = ingredientsList.join(';'); // on fait un string à partir de la liste d'ingrédients

                  String couleurPlat;   //param pour la couleur que le plat aura

                  double CO2pour100=(finalCO2/quantitePlat)*100;  // calcul de la quantité de CO2 émis pour 100g de plat.

                  if (CO2pour100 < 150) {   //si < à 150 le plat est vert
                    couleurPlat = 'Vert';
                  } else if (CO2pour100 > 450) {  //si > à 450 le plat est rouge
                    couleurPlat = 'Rouge';
                  } else {
                    couleurPlat = 'Jaune';  // sinon c'est qu'il est jaune
                  }


                  // Créer le plat avec les données formatées
                  final plat = {
                    'nom': _controllerNomPlat.text,  // recup depuis le textfield du nom
                    'couleur': couleurPlat,
                    'ingredients': ingredients,
                    'prix': _controllerPrix.text, // recup depuis le textfield du prix
                  };

                  try {
                    await DatabaseHelper.instance.insertPlat(plat); // Enregistrer le plat dans la base de données
                    print("Insertion réussie");

                    Navigator.pushReplacement(  // Retourner à la page du menu une fois sauvegarder

                    context,
                      MaterialPageRoute(builder: (context) => pageMenu()),
                    );

                  } catch (e) {
                    print("Erreur lors de l'insertion");
                    }
                    }
                    },
              child: const Text('Valider'),
            ),

          ],
        ),
      ),
    );
  }
}
