import 'package:flutter/material.dart';
import 'database.dart';

class RecipeIngredient {
  final String name;
  final Color? color;
  final String ValCarbone;

  RecipeIngredient({required this.name, this.color,required this.ValCarbone});
}

class pageVisu extends StatelessWidget {  // page pour visu le plat aprés qu'on ait cliqué dessus
  final String recette;

  pageVisu({required this.recette}); // plat selectionné

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getRecipeDetails(),  // appel de la fonc pour recup les infos du plat
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { // si met du temps avant d'avoir les infos du plat on met une icone de chargement
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur de chargement des détails de la recette'); // si erreur lors de recup des infos
        } else {
          final Map<String, dynamic> recetteDetail = snapshot.data!;
          if (recetteDetail.isEmpty) {  // si erreur et que le plat select n'existe pas dans la BD
            return Text('Recette non trouvée dans la base de données');
          } else {

            String recetteString = recetteDetail['ingredients'];  // formatage des donne du plat pour les afficheer
            List<String> recipes = recetteString.split(';');
            List<RecipeIngredient> ingredients = [];

            recipes.forEach((recipe) {
              List<String> recipeDetails = recipe.split(',');
              if (recipeDetails.length >= 2) {
                String name = recipeDetails[0];
                Color? color = _parseColor(recipeDetails[1]); // appel de la fonction qui apartir d'un string renvoie sa couleur
                String ValCarbone=recipeDetails[2];
                ingredients.add(RecipeIngredient(name: name, color: color,ValCarbone:ValCarbone));
              } else {
                print('Erreur : Les détails de la recette ne sont pas complets.');
              }
            });

            return Scaffold( // mise en forme de la page
                appBar: AppBar(
                  title: Text(ingredients.isNotEmpty ? recetteDetail['nom'] : 'Aucune recette'),
                ),
                body: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _parseColor(recetteDetail['couleur'] ?? ''),
                        ),
                      ),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ Text(
                          double.parse(recetteDetail['emission']).toStringAsFixed(3)+" grammes de C02",
                        )
                        ]

                    ),

                    Divider(),
                    Expanded(
                      child: ListView.separated(
                        itemCount: ingredients.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(

                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ingredients[index].color ?? Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(ingredients[index].name + '\n' + double.parse(ingredients[index].ValCarbone).toStringAsFixed(3) + " grammes de CO2 "),
                                )

                              ],
                            ),
                          );
                        },
                      ),

                    )
                  ],
                )
            );
          }
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getRecipeDetails() async {  // pour recup détail du plat selectionné au début
    try {
      // Récupérer les détails de la recette depuis la base de données
      return await DatabaseHelper.instance.getPlat(recette) ?? {};
    } catch (e) {
      print('Erreur lors de la récupération des détails de la recette: $e');
      return {};
    }
  }

  Color? _parseColor(String colorString) {
    switch (colorString.toLowerCase().replaceAll(' ', '')) {
      case 'rouge':
        return Colors.red;
      case 'vert':
        return Colors.green;
      case 'jaune':
        return Colors.yellow;
      case 'vertf':
        return Color.fromRGBO(12, 126, 12, 1.0);
      case 'orange':
        return Color.fromRGBO(197, 119, 0, 1.0);
      default:
        return null;
    }
  }
}