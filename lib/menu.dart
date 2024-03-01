import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'CreationPlat.dart';
import 'visuPlat.dart';
import 'package:csv/csv.dart';

class pageMenu extends StatefulWidget {
  @override
  _pageMenuState createState() => _pageMenuState();
}

class _pageMenuState extends State<pageMenu> {
  List<String> buttonTexts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String csvString = await rootBundle.loadString('assets/plat.csv');
    final List<List<dynamic>> fields = CsvToListConverter().convert(csvString);
    // Assuming the first column contains the dish names
    setState(() {
      for (final row in fields) {
        buttonTexts.add(row[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page des menus'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pageCreation()),
                );
              },
              child: Text('Ajouter un plat'),
            ),
            SizedBox(height: 20),
            Text(
              'Contenu sous le bouton',
              style: TextStyle(fontSize: 18),
            ),
            if (buttonTexts.isNotEmpty)
              Column(
                children: buttonTexts.map(
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
            if (buttonTexts.isEmpty)
              CircularProgressIndicator(), // Affichez une indication de chargement tant que les données ne sont pas chargées
          ],
        ),
      ),
    );
  }
}
