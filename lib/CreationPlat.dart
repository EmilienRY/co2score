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
                              // Mettre à jour le texte de l'ingrédient dans la ligne en cours
                              ListIngredient[index].controllerIngredient.text = selectedIngredient;
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

                // Vérifier si le nom du plat existe déjà dans la base de données
                bool platExists = await DatabaseHelper.instance.getPlat(_controllerNomPlat.text) != null;

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

                  // Construire la liste des ingrédients au format requis
                  List<String> ingredientsList = [];
                  double finalCO2=0;
                  double quantitePlat=0;
                  for (IngredientRow row in ListIngredient) {
                    String ingredient = row.controllerIngredient.text;
                    double? quantity = double.tryParse(row.controllerQuantity.text.replaceAll(',', '.'));

                    if (quantity != null) {
                      // Récupérer la valeur de l'ingrédient depuis la base de données
                      Map<String, dynamic>? ingredientData = await DatabaseHelper.instance.getIngredient(ingredient);
                      if (ingredientData != null) {
                        double? value = double.tryParse(ingredientData['valeur'].replaceAll(',', '.'));
                        if(value == null){
                          ingredientsList.add('$ingredient,rouge');
                        }
                        else{
                          double GparKG=value*1000;
                          double GparG=GparKG/10;
                          double totalCO2 = quantity * (GparG/100);
                          quantitePlat+=quantity;
                          finalCO2+=totalCO2;

                          String color;

                          // Déterminer la couleur en fonction du total de CO2
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

                  // Convertir la liste en une seule chaîne séparée par des points-virgules
                  String ingredients = ingredientsList.join(';');

                  String couleurPlat;

                  double CO2pour100=(finalCO2/quantitePlat)*100;

                  if (CO2pour100 < 150) {
                    couleurPlat = 'Vert';
                  } else if (CO2pour100 > 450) {
                    couleurPlat = 'Rouge';
                  } else {
                    couleurPlat = 'Jaune';
                  }


                  // Créer le plat avec les données formatées
                  final plat = {
                    'nom': _controllerNomPlat.text,
                    'couleur': couleurPlat, // Couleur choisie au hasard pour l'exemple
                    'ingredients': ingredients,
                    'prix': _controllerPrix.text,
                  };

                  try {
                    await DatabaseHelper.instance.insertPlat(plat); // Enregistrer le plat dans la base de données
                    print("Insertion réussie");

                    // Retourner à la page du menu
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => pageMenu()), // Remplacer la page actuelle par la page du menu
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
