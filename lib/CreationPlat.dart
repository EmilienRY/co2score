import 'package:flutter/material.dart';
import 'menu.dart';


class pageCreation extends StatelessWidget {   //page avec la liste des plats
  @override

    final  TextField ingredient=TextField(
    obscureText: true,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Ingrédient',
    ),
  );
  final List <TextField> ListIngredient =[TextField(
  obscureText: true,
  decoration: InputDecoration(
  border: OutlineInputBorder(),
  labelText: 'Ingrédient',
  ),
  ),];
  Widget build(BuildContext context) {
    void _ajoutIngredient(){
      ListIngredient.add(ingredient);
      print(ListIngredient);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pageCreation()), // Passe à la page avec la liste de tous les plats
      );
      }
      void _supIngredient(){
      ListIngredient.remove(ListIngredient.last);
      }

    return Scaffold(
      appBar: AppBar(
        title:  Text('Créer votre plat'),
      ),
      body: Center(
      child:Column(
      children: [
      Column(children: ListIngredient),
      Column(
        children: [
      const SizedBox(height: 30),
        ElevatedButton(
        onPressed: () {
          _ajoutIngredient();
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
      ],
      ),
      ],),),);
}}
