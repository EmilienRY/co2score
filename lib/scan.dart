import 'package:flutter/material.dart';
import 'dart:convert';

class RecipeIngredient {
  final String name;
  final Color color;
  RecipeIngredient({required this.name, required this.color});
}

class Recipe {
  final String name;
  final Color color;
  final List<RecipeIngredient> ingredients;

  Recipe({required this.name, required this.color, required this.ingredients});
}

class PageScan extends StatelessWidget {
  final String scan;

  PageScan({required this.scan});

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = [];

    try {

      final compressedData = base64.decode(scan);
      final decompressedData = utf8.decode(compressedData);
      final List<String> ListePlats = decompressedData.split('}{');

      for (int i = 0; i < ListePlats.length; i++) {
        ListePlats[i] = ListePlats[i].replaceAll(RegExp(r'[{}]+'), '');
      }

      for (final recette in ListePlats) {
        String jsonString = '{' + recette + '}';
        Map<String, dynamic> plat = jsonDecode(jsonString);

        final String name = plat['nom'];
        final String colorString = plat['couleur'];
        final Color color = _parseColor(colorString);
        final String ingredientsString = plat['ingredients'];

        final List<RecipeIngredient> ingredients = [];

        final List<String> ingredientList = ingredientsString.split(';');

        ingredientList.forEach((ingredient) {
          final List<String> parts = ingredient.split(',');
          if (parts.length == 2) {
            ingredients.add(RecipeIngredient(
                name: parts[0], color: _parseColor(parts[1])));
          }
        });

        recipes.add(Recipe(name: name, color: color, ingredients: ingredients));
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Plats du menu'),
        ),
        body: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: recipes[index].color,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(recipes[index].name),
                    ],
                  ),
                ),
                Divider(), // Ajoute une séparation entre chaque plat
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recipes[index].ingredients.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: recipes[index].ingredients[i].color,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(recipes[index].ingredients[i].name),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erreur de format'),
        ),
        body: Center(
          child: Text('Le format du code QR est incorrect ou le scan à échoué.'),
        ),
      );
    }
  }

  Color _parseColor(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'rouge':
        return Colors.red;
      case 'vert':
        return Colors.green;
      case 'jaune':
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }
}
