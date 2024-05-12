import 'package:flutter/material.dart';
import 'dart:convert';
import 'dataBaseServ.dart';

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

class visuServ extends StatelessWidget {
  final PlatInfo? plat; // param d'entré

  visuServ({required this.plat});

  @override
  Widget build(BuildContext context) {
    List<RecipeIngredient> recipes = [];

    if(plat!=null) {  // on vérifie qu'on a bien un plat

      final List<String> ListePlats = plat!.ingredients.split(';'); // on traite la string
      print(ListePlats);
      double em=0;
      for (int i = 0; i < ListePlats.length; i++) {
        List<String> l=[];
        l=ListePlats[i].split(',');
        em+=double.parse(l[2]);
        recipes.add(RecipeIngredient(name:l[0],color:_parseColor(l[1]),val:l[2]));
      }

      final String name = plat!.nom;
      final String colorString = plat!.couleur;
      final Color color = _parseColor(colorString);
      final String emission = em.toString();;

      Recipe recette =Recipe(name: name, color: color, ingredients: recipes,emission: emission);


      return Scaffold( // affichage de la recette
        appBar: AppBar(
          title: Text(plat!.nom),
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
                  color: recette.color,
                ),
              ),
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ Text(
                  double.parse(recette.emission).toStringAsFixed(3)+" grammes de C02",
                )
                ]

            ),

            Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: recette.ingredients.length,
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
                            color: recette.ingredients[index].color ?? Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(recette.ingredients[index].name + '\n' + double.parse(recette.ingredients[index].val).toStringAsFixed(3) + " grammes de CO2 "),
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
    else {  // erreur lorsqu'on a recup le plat
      return Scaffold(
        appBar: AppBar(
          title: Text('erreur lors de la récupération du plat'),
        ),
        body: Center(
          child: Text('la récupération du plat à échoué.'),
        ),
      );
    };
  }

  Color _parseColor(String colorString) {  // fonction pour recup les couleurs
    switch (colorString.toLowerCase()) {
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
        return Colors.black;
    }
  }
}