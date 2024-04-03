import 'package:flutter/material.dart';
import 'dart:convert';

class RecipeIngredient {   // classe des ingrédients
  final String name;
  final Color color;
  final String val;
  RecipeIngredient({required this.name, required this.color,required this.val});
}

class Recipe {  // classe des recettes   ces 2 classes sont la pour faciliter affichage par la suite
  final String name;
  final Color color;
  final List<RecipeIngredient> ingredients;
  final String emission;
  Recipe({required this.name, required this.color, required this.ingredients,required this.emission});
}

class PageScan extends StatelessWidget {
  final String scan; // param d'entré

  PageScan({required this.scan});

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = [];

    try {  // on essaye de décoder la donnée scan. ( elle est compressé) . Tout est dans un try catch car si donné pas comme voulue cela va créer une erreur qui serait fatale

      final compressedData = base64.decode(scan);  // décompression
      final decompressedData = utf8.decode(compressedData);
      final List<String> ListePlats = decompressedData.split('}{');
      print(ListePlats);

      for (int i = 0; i < ListePlats.length; i++) {
        ListePlats[i] = ListePlats[i].replaceAll(RegExp(r'[{}]+'), '');
      }

      for (final recette in ListePlats) {  // traitements des strings de chaques plats
        String jsonString = '{' + recette + '}';
        Map<String, dynamic> plat = jsonDecode(jsonString);
        print(plat);
        final String name = plat['nom'];
        final String colorString = plat['couleur'];
        final Color color = _parseColor(colorString);
        final String ingredientsString = plat['ingredients'];
        final String emission = plat['emission'];

        final List<RecipeIngredient> ingredients = [];

        final List<String> ingredientList = ingredientsString.split(';');

        ingredientList.forEach((ingredient) {
          final List<String> parts = ingredient.split(',');
          if (parts.length == 3) {
            ingredients.add(RecipeIngredient(name: parts[0], color: _parseColor(parts[1]),val: parts[2]));

          }

        });

        recipes.add(Recipe(name: name, color: color, ingredients: ingredients,emission: emission));
      }

      return Scaffold( // affichage des recettes
        appBar: AppBar(
          title: Text('Plats du menu'),
        ),
        body: ListView.builder(   // affichage de la liste des ingredients + couleurs  pour chaques plats
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
                      Text(recipes[index].name+", "+recipes[index].emission+ " grammes de C02" ),
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
                          Expanded(child:
                          Text(
                            recipes[index].ingredients[i].name + '\n' +  double.parse(recipes[index].ingredients[i].val).toStringAsFixed(3) + " grammes de CO2 ",
                            softWrap: true,
                          ),
                          )

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
    }
    catch (e) {  // si on a une erreur lorsqu'on traite les données => le qr code scanné n'est pas valide ou il y a eu un problème de lecture du qr code et il faut le re scan
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

  Color _parseColor(String colorString) {  // fonction pour recup les couleurs
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
