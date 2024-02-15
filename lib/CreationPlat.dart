import 'package:flutter/material.dart';



class pageCreation extends StatelessWidget {   //page avec la liste des plats
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Créer votre plat'),
      ),

    body: const Column(
      children: <Widget> [
      Expanded(
      flex: 5,
        child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ingrédient 1',
            ),
        ),),
      ElevatedButton(
        onPressed: null,
        child: const Text('Disabled'),
    ),
    const SizedBox(height: 30),
      ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageCreation()), // Passe à la page avec la liste de tous les plats
        );
      },
    child: const Text('Enabled'),
    ),
    ],
    ),
    );
}}

