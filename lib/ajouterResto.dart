import 'package:flutter/material.dart';


class IngredientRow {
  TextEditingController controllerIngredient = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
}

class ajouterResto extends StatefulWidget {

  @override
  _ajouterRestoState createState() => _ajouterRestoState();
}

class _ajouterRestoState extends State<ajouterResto> {
  final TextEditingController _controllerNomPlat = TextEditingController();
  final TextEditingController _controllerPrix = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ajouter un établissement'),
      ),
      body: Center(

      ),
    );
  }
}