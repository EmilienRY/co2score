import 'package:flutter/material.dart';
import 'CreationPlat.dart';
import 'visuPlat.dart';

class pageMenu extends StatelessWidget {   //page avec la liste des plats

  final List<String> buttonTexts = ['Page 1', 'Page 2', 'Page 3','page4', 'Page 3', 'Page 3', 'Page 3', 'Page 3', 'Page 3'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page des menus'),
      ),

      body: Center(
      child :Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pageCreation()), // Passe à la page avec la liste de tous les plats
              );
            },
            child: Text('Ajouter un plat'),
          ),
          SizedBox(height: 20), // Espacement entre le bouton et le contenu suivant
          Text(
            'Contenu sous le bouton',
            style: TextStyle(fontSize: 18),
          ),
          Column(children: buttonTexts.map(
                  (text) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => pageVisu(),
                    ),
                  );
                },
                child: Text(text),
              ),
            ).toList(),
          ),
        ],
        ),


      ),


    );
  }
}