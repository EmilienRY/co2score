import 'package:flutter/material.dart';

class PageScan extends StatelessWidget {
  final String scan;

  // Constructeur avec un paramètre de type String
  PageScan({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scan), // Utilisation du paramètre pour le titre de l'appBar
      ),
    );
  }
}
