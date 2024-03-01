import 'package:flutter/material.dart';

class RecipeIngredient {  // classe pour stocker chaques ingrédients
  final String name;
  final Color color;

  RecipeIngredient({required this.name, required this.color});
}

class PageScan extends StatelessWidget {
  final String scan;
  final RegExp recipeRegex = RegExp(r'([^,]+,(Rouge|Vert|Jaune);)*([^,]+,(Rouge|Vert|Jaune))'); // Modèle de chaîne pour une recette valide (possible modif si plus de couleur)


  // Constructeur avec un paramètre de type String
  PageScan({required this.scan});

  @override
  Widget build(BuildContext context) {

    if (!recipeRegex.hasMatch(scan)) { // on vérifie que la chaine ait le bon format avec l'expression régulière
      return Scaffold(
        appBar: AppBar(
          title: Text('Erreur de format'), // Titre d'erreur si la chaîne n'est pas au bon format
        ),
        body: Center(
          child: Text('Le format du code QR est incorrect.'),
        ),
      );
    }




    // Diviser la chaîne scan en une liste d'ingrédients
    List<String> recipes = scan.split(';');
    List<RecipeIngredient> ingredients = [];


    // Parcourir la liste des recettes et des ingrédients pour les séparer
    recipes.forEach((recipe) {
      List<String> recipeDetails = recipe.split(',');

      if (recipeDetails.length >= 2) {
        String name = recipeDetails[0];
        Color color = _parseColor(recipeDetails[1]); //recupération de la couleur
        ingredients.add(RecipeIngredient(name: name, color: color));
      } else {
        // print erreur si les détails de la recette ne sont pas complets
        print('Erreur : Les détails de la recette ne sont pas complets.');
      }
    });


    return Scaffold(
      appBar: AppBar(
        title: Text(ingredients.isNotEmpty ? ingredients.first.name : 'Aucune recette'), // Utilisation du nom de la première recette comme titre de l'appBar si disponible
      ),
      body: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Container(   //affichage d'un petit cercle avec une couleur pour indiquer impact ingrédient
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ingredients[index].color,
                  ),
                ),
                SizedBox(width: 10),
                Text(ingredients[index].name), // Afficher le nom de l'ingrédient
              ],
            ),
          );
        },
      ),
    );
  }

  // Méthode pour convertir une couleur en chaîne en objet Color
  Color _parseColor(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'rouge':
        return Colors.red;
      case 'vert':
        return Colors.green;   // a modifier si on veut plus de couleurs
      case 'jaune':
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }
}
