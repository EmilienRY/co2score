import 'package:flutter/material.dart';
import 'menu.dart';


class pageCreation extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<pageCreation> {
    final  TextField ingredient=TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Ingrédient',
    ),
  );
  final List <TextField> ListIngredient=[];
  Widget build(BuildContext context) {
    void _ajoutIngredient(){
      setState(() {
        ListIngredient.add(ingredient);
        const SizedBox(height: 10);
      });
      }
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
        //obscureText: true,        pour mettre en mode mot de passe
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
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Valider'),
          ),
      ],
      ),
      ],),),);
}}
