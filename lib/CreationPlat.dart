import 'package:flutter/material.dart';


class pageCreation extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<pageCreation> {
  final TextEditingController _controllerNomPlat = TextEditingController();
  //TextEditingController _controllerIngredient = TextEditingController();

/*    final  TextField ingredient=TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Ingrédient',
    ),
  );*/

  final List <TextField> ListIngredient=[];
  Widget build(BuildContext context) {
 /*   void _ajoutIngredient(){
      setState(() {
        ListIngredient.add(ingredient);
        const SizedBox(height: 10);
      });
      }*/
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
