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
  final TextEditingController _controllerNomPlat = TextEditingController();
  final TextEditingController _controllerPrix = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chercher les plats \n pour un établissement'),
      ),
      body: Center(

      ),
    );
  }
}