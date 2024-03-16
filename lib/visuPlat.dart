import 'package:flutter/material.dart';
import 'database.dart'; // Importez la classe Database

class RecipeIngredient {
  final String name;
  final Color? color;

  RecipeIngredient({required this.name, this.color});
}

class pageVisu extends StatelessWidget {
  final String recette;

  pageVisu({required this.recette});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getRecipeDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur de chargement des détails de la recette');
        } else {
          final Map<String, dynamic> recetteDetail = snapshot.data!;
          if (recetteDetail.isEmpty) {
            return Text('Recette non trouvée dans la base de données');
          } else {
            String recetteString = recetteDetail['ingredients'];
            List<String> recipes = recetteString.split(';');
            List<RecipeIngredient> ingredients = [];

            recipes.forEach((recipe) {
              List<String> recipeDetails = recipe.split(',');
              if (recipeDetails.length >= 2) {
                String name = recipeDetails[0];
                Color? color = _parseColor(recipeDetails[1]);
                ingredients.add(RecipeIngredient(name: name, color: color));
              } else {
                print('Erreur : Les détails de la recette ne sont pas complets.');
              }
            });

            return Scaffold(
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
                          Text(ingredients[index].name),
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

  Future<Map<String, dynamic>> _getRecipeDetails() async {
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
      default:
        return null;
    }
  }
}
