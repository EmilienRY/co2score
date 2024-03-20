import 'package:flutter/material.dart';
import 'database.dart';

class pageCreation extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<pageCreation> {
  final TextEditingController _controllerNomPlat = TextEditingController();


  final List <TextField> ListIngredient=[];
  Widget build(BuildContext context) {

      void _supIngredient(){
      setState(() {
        ListIngredient.remove(ListIngredient.last);
      });
      }

    return Scaffold(
      appBar: AppBar(
        title:  Text('Créer votre plat'),
      ),
      body: Center(
      child:Column(
      children: [
        Column(children: [
          const SizedBox(height: 30),
        TextField(
          controller: _controllerNomPlat,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nom du plat',
        ),
      ),],
      ),
      Column(children: ListIngredient),
      Column(
        children: [
      const SizedBox(height: 30),
        ElevatedButton(
        onPressed: () {
          setState(() {
            TextEditingController controllerIngredient = TextEditingController();
            ListIngredient.add(TextField(
              controller: controllerIngredient,
                onSubmitted: (String value)async {
                },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingrédient',
              ),
            ),
            );
            const SizedBox(height: 10);
          });
        },
      child: const Text('Ajouter un ingrédient'),
      ),
      const SizedBox(height: 30),
      ElevatedButton(
        onPressed: () {
          _supIngredient();
        },
        child: const Text('Supprimer un ingrédient'),
      ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              String nomPlat = _controllerNomPlat.text;
              // Afficher la chaîne de caractères dans la console
              print('Le texte saisi est : $nomPlat');
              _controllerNomPlat.dispose();
              String ingredients="";
              for (TextField Ingredient in ListIngredient) {
                String ingredient = Ingredient.controller!.text;
                final database = DatabaseHelper.instance;
                database.getIngredient(ingredient).then((ingr){
                  if (ingr != null) {
                    final val = ingr['valeur'];
                    ingredients = ingredients + ingredient + ',Vert;';
                  }
                });
                print('Text saisi: $ingredient');
                ingredients=ingredients+ingredient+',Vert;';
              }
              print('$ingredients');
            },
            child: const Text('Valider'),
          ),
      ],
      ),
      ],
      ),
      ),
    );
}}
