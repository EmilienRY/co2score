import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as p;
import 'database.dart';

class GeneratePdfPage extends StatefulWidget {
  @override
  _GeneratePdfPageState createState() => _GeneratePdfPageState();
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  List<String> selectedPlats = [];
  List<String> plats = [];

  @override
  void initState() {
    super.initState();
    fetchPlatsFromDatabase();
  }

  Future<void> fetchPlatsFromDatabase() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final platsList = await dbHelper.queryAllPlats();
      setState(() {
        plats = platsList.map((plat) => plat['nom'] as String).toList();
      });
    } catch (e) {
      print("Erreur lors de la récupération des plats depuis la base de données : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choisissez les plats à inclure dans le PDF :',
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: plats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final plat = plats[index];
                    return CheckboxListTile(
                      title: Text(plat),
                      value: selectedPlats.contains(plat),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            selectedPlats.add(plat);
                          } else {
                            selectedPlats.remove(plat);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () async {
                  String path = await makePdf(selectedPlats);
                  openPdfExternally(path);
                },
                child: Text("Créer le PDF"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> makePdf(List<String> selectedPlats) async {
    Directory? downloadsDirectory = await getDownloadsDirectory();

    if (downloadsDirectory == null) {
      throw FileSystemException("Impossible d'accéder au répertoire de téléchargement.");
    }

    final pdf = p.Document();
    pdf.addPage(
      p.Page(
        build: (context) {
          return p.Column(
            children: [
              p.Text("Liste des plats sélectionnés :"),
              for (var plat in selectedPlats)
                p.Text(plat),
                p.Container(
                  width: 20,
                  height: 20,
                  decoration: p.BoxDecoration(
                    shape: p.BoxShape.circle,
                    color: p.ingredients[index].color ?? Colors.black,
                  ),
                )
            ],
          );
        },
      ),
    );

    String path = '${downloadsDirectory.path}/menu.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    print("Chemin : " + path);
    return path;
  }

  void openPdfExternally(String path) async {
    try {
      await OpenFile.open(path);
    } catch (e) {
      print("Erreur lors de l'ouverture du PDF: $e");
    }
  }
}
