import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as p;
import 'database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'dart:convert';


class GeneratePdfPage extends StatefulWidget {
  @override
  _GeneratePdfPageState createState() => _GeneratePdfPageState();
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  List<String> selectedPlats = [];
  List<Future<PdfColor>> couleursPlats = [];   // liste de couleurs pour pdf
  List<String> plats = [];

  @override
  void initState() {
    super.initState();
    fetchPlatsFromDatabase();
  }

  Future<void> fetchPlatsFromDatabase() async {   //pour recup tout les plats et les afficher
    try {
      final dbHelper = DatabaseHelper.instance;
      final platsList = await dbHelper.queryAllPlats();
      setState(() {
        plats = platsList.map((plat) => plat['nom'] as String).toList();
      });
    } catch (e) {
      print("Erreur lors de la récupération des plats depuis la base de données : $e"); //affiche ca si erreur
    }
  }


  @override
  Widget build(BuildContext context) {   //page de selection
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('créer une étiquette'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Choisissez les plats à inclure dans le PDF :',
              ),
              Expanded(
                child: ListView.builder(   // liste des plats à cocher
                  itemCount: plats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final plat = plats[index];
                    return CheckboxListTile(
                      title: Text(plat),
                      value: selectedPlats.contains(plat),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {   //si on coche on rajoute a selectedPlats et couleursPlats
                            selectedPlats.add(plat);
                            couleursPlats.add(_getPlatColor(plat));  // on recup la couleur du plat avec fonction _getPlatColor
                          } else {
                            selectedPlats.remove(plat); //si on décoche on enlève
                            couleursPlats.remove(_getPlatColor(plat));
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              TextButton(   //bouton pour générer pdf
                onPressed: () async {
                  String path = await makePdf(selectedPlats); //appel la fonction pour faire pdf et on recup le chemin d'accé
                  ouverturePDF(path); //ouverture du pdf
                },
                child: Text("Créer le PDF"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> makePdf(List<String> selectedPlats) async {  //fonction de génération et ouverture pdf
    Directory? downloadsDirectory = await getDownloadsDirectory();
    List<PdfColor> colors = await Future.wait(couleursPlats);   //on recup les couleurs des plats selectionnés

    if (downloadsDirectory == null) {
      throw FileSystemException("Impossible d'accéder au répertoire de téléchargement.");
    }

    final qrImageData = await _generateQrImageData(selectedPlats); // Appel de la fonction _generateQrImageData pour faire le qrcode

    final pdf = p.Document();  //création du pdf

    pdf.addPage(   //etiquette
      p.Page(
        build: (context) {
          return p.Column(
            children: [
              p.Text("Menu du jour :"),
              for (var i = 0; i < selectedPlats.length; i++)
                p.Row(
                    children: [
                      p.Text(selectedPlats[i]),  //nom du plat
                      p.Container(
                        width: 20,
                        height: 20,
                        decoration: p.BoxDecoration(
                          shape: p.BoxShape.circle,
                          color: colors[i],    // pastille de couleur du plat
                        ),
                      ),
                    ]
                ),
              p.SizedBox(height: 20),
              p.Text("détails du menu "),   //qrcode
              p.Container(
                width: 100,
                height: 100,
                child: p.Image(p.MemoryImage(qrImageData)),
              ),
            ],
          );
        },
      ),
    );

    String path = '${downloadsDirectory.path}/menu.pdf';   // la ou on va mettre le pdf
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    print("Chemin : " + path);
    return path;   // on renvoi le chemin ou on a dl pdf
  }


  Future<PdfColor?> _parseColor(String colorString) async {   // on recup couleurs (type PdfColor pour mettre dans pdf)
    switch (colorString.toLowerCase().replaceAll(' ', '')) {
      case 'rouge':
        return PdfColor.fromHex('#FF0000');
      case 'vert':
        return PdfColor.fromHex('#008000');
      case 'jaune':
        return PdfColor.fromHex('#FFFF00');
      default:
        return null;
    }
  }

  Future<PdfColor> _getPlatColor(String platName) async {  // fonction pour recup couleur du plat dans base de donnée
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(platName);
    if (plat != null) {
      final colorString = plat['couleur'] as String;
      final color = await _parseColor(colorString);
      if (color != null) {
        return color;
      }
    }
    return PdfColor.fromHex('#808080');  // si problème pour trouver couleur met du gris
  }

  void ouverturePDF(String path) async {  // pour ouvrir le pdf avec appli extérieur
    try {
      await OpenFile.open(path);
    } catch (e) {
      print("Erreur lors de l'ouverture du PDF: $e");
    }
  }


  Future<Uint8List> _generateQrImageData(List<String> selectedPlats) async {  // génération du qrcode à partir de la liste des plats selctionnés
    final StringBuffer qrDataBuffer = StringBuffer();

    // Construction de la chaîne pour le QR code
    for (int i = 0; i < selectedPlats.length; i++) {
      final plat = await _getPlatIngredients(selectedPlats[i]);  // appel de fonction qui recup tout les ingrédient du plat depuis bd
      if (plat != null) {
        final platData = {
          'nom': plat['nom'],
          'couleur': plat['couleur'],
          'ingredients': plat['ingredients'],
        };
        final platJson = jsonEncode(platData);  //on fait chaine au format json pour plus de lisibilité
        qrDataBuffer.write(platJson);
      }
    }

    final compressedData = utf8.encode(qrDataBuffer.toString());  // on compresse les donne (si on ne le fait pas le qrcode généré peut le pas être lisible)
    final compressedDataString = base64.encode(compressedData);
    print(compressedData);

    final qrPainter = QrPainter(        // Création du QR code avec les données compressées
    data: compressedDataString,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,     // deprecated mais fonctionne bien
      emptyColor: Colors.white,
    );

    final qrCode = await qrPainter.toImageData(200.0);
    if (qrCode != null) {
      return Uint8List.fromList(qrCode.buffer.asUint8List());  // on retourne le qrcode
    } else {
      throw Exception("Erreur lors de la génération du QR code");
    }
  }


  Future<Map<String, dynamic>?> _getPlatIngredients(String platName) async {  // recup les infos du plat depuis bd
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(platName);
    return plat;
  }


}
