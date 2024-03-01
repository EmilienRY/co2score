import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class RecipeIngredient {
  final String name;
  final Color? color;

  RecipeIngredient({required this.name, this.color});
}

class pageVisu extends StatelessWidget {
  final String recette;

  pageVisu({required this.recette});

  Future<List<List<dynamic>>> lireFichierCsv(String chemin) async {
    final data = await rootBundle.loadString(chemin);
    return CsvToListConverter().convert(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>>(
      future: lireFichierCsv('assets/plat.csv'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur de chargement du fichier');
        } else {
          var data = snapshot.data!;
          var recetteDetail = data.firstWhere((row) => row[0] == recette, orElse: () => []);

          if (recetteDetail.isEmpty) {
            return Text('Recette non trouvée dans le fichier');
          } else {
            String inter = recetteDetail.toString();
            String recetteString=inter.replaceAll('[', '').replaceAll(']', '');
            print(recetteString);

            List<String> recipes = recetteString.split(';');
            print(recipes);
            List<RecipeIngredient> ingredients = [];

            recipes.forEach((recipe) {
              List<String> recipeDetails = recipe.split(',');
              print(recipeDetails);
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
                title: Text(ingredients.isNotEmpty ? ingredients.first.name : 'Aucune recette'),
              ),
              body: ListView.separated(
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
            );
          }
        }
      },
    );
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
