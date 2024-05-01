import 'package:flutter/material.dart';


class IngredientRow {
  TextEditingController controllerIngredient = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
}

class chercheResto extends StatefulWidget {

  @override
  _chercheRestoState createState() => _chercheRestoState();
}

class _chercheRestoState extends State<chercheResto> {
  final TextEditingController _controllerNomResto = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chercher les plats \n pour un établissement'),
      ),
      body: Center(
        child: Column(
            children: [
              TextField(
                controller: _controllerNomResto,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nom de l'établissement",
                ),
              ),
            ]
        ),
      ),
    );
  }
}