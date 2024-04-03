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

class PlatInfo {
  final String nom;
  final Color couleur;
  final String prix;

  PlatInfo(this.nom, this.couleur, this.prix);
}


class GeneratePdfPage extends StatefulWidget {
  @override
  _GeneratePdfPageState createState() => _GeneratePdfPageState();
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  List<PlatInfo> selectedPlats = [];
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
                child: ListView.builder(
                  itemCount: plats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final plat = plats[index];
                    return CheckboxListTile(
                      title: Text(plat),
                      value: selectedPlats.any((element) => element.nom == plat),
                      onChanged: (bool? value){
                        setState(() {
                          if (value != null && value) {
                            addPlat(plat);
                            //selectedPlats.add(PlatInfo(plat, await _getPlatColor(plat), await _getPlatPrice(plat)));
                          } else {
                            removePlat(plat);
                            //selectedPlats.removeWhere((element) => element.nom == plat);
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


  // Définir une fonction asynchrone pour ajouter un plat à selectedPlats
  Future<void> addPlat(String plat) async {
    var couleur = await _getPlatColor(plat);
    var prix = await _getPlatPrice(plat);
    setState(() {
      selectedPlats.add(PlatInfo(plat, couleur, prix));
    });
  }

// Définir une fonction pour retirer un plat de selectedPlats
  void removePlat(String plat) {
    setState(() {
      selectedPlats.removeWhere((element) => element.nom == plat);
    });
  }



  Future<String> makePdf(List<PlatInfo> selectedPlats) async {  //fonction de génération et ouverture pdf
    Directory? downloadsDirectory = await getDownloadsDirectory();

    if (downloadsDirectory == null) {
      throw FileSystemException("Impossible d'accéder au répertoire de téléchargement.");
    }

    final qrImageData = await _generateQrImageData(selectedPlats); // Appel de la fonction _generateQrImageData pour faire le qrcode
    final Map<String, Uint8List> platQR = {};

    for (final plat in selectedPlats){
      platQR[plat.nom] = await _generateQrUnique(plat, plat.couleur);

    }

    final pdf = p.Document();  //création du pdf

    pdf.addPage(   //etiquette
      p.Page(
        build: (context) {
          return p.Column(
            children: [
              p.Text("Menu du jour :", style: p.TextStyle(fontSize: 40, fontWeight: p.FontWeight.bold)), // Titre avec une police plus grosse
              p.SizedBox(width: 35),
              for (var platInfo in selectedPlats)
                p.Container(
                  padding: const p.EdgeInsets.symmetric(vertical: 8), // Ajout d'un espace vertical entre chaque plat
                  child: p.Row(
                    crossAxisAlignment: p.CrossAxisAlignment.center,
                    mainAxisAlignment: p.MainAxisAlignment.center,
                    children: [
                      p.Text("${platInfo.nom}", style: p.TextStyle(fontSize: 25, fontWeight: p.FontWeight.bold)), // Nom du plat avec une police plus grosse
                      p.SizedBox(width: 10), // Ajout d'un espace horizontal entre le nom du plat et le prix
                      p.Text("${platInfo.prix}", style: p.TextStyle(fontSize: 20)), // Prix du plat
                      p.SizedBox(width: 15), // Ajout d'un espace horizontal entre le prix et la couleur
                      p.Container(
                        width: 65,
                        height: 65,
                        child: p.Image(
                            p.MemoryImage(
                                platQR[platInfo.nom]!
                        )
                      ),
                      ),
                    ],
                  ),
                ),
              p.SizedBox(height: 20), // Ajout d'un espace vertical entre chaque plat
              p.Text("Pour voir tout le menu :"),   //qrcode

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


  Future<Color?> _parseColor(String colorString) async {   // on recup couleurs (type PdfColor pour mettre dans pdf)
    switch (colorString.toLowerCase().replaceAll(' ', '')) {
      case 'rouge':
        return Colors.red;
      case 'vert':
        return Colors.green;
      case 'jaune':
        return Color.fromRGBO(153, 153, 0, 1);
      default:
        return null;
    }
  }

  Future<Color> _getPlatColor(String platName) async {  // fonction pour recup couleur du plat dans base de donnée
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(platName);
    if (plat != null) {
      final colorString = plat['couleur'] as String;
      final color = await _parseColor(colorString);
      if (color != null) {
        return color;
      }
    }

    return Colors.black;  // si problème pour trouver couleur met du gris
  }

  Future<String> _getPlatPrice(String platName) async { // pour recup le prix du plat
    final dbHelper = DatabaseHelper.instance;
    final plat = await dbHelper.getPlat(platName);
    if (plat != null) {
      return plat['prix'] as String;
    }
    return '';
  }


  void ouverturePDF(String path) async {  // pour ouvrir le pdf avec appli extérieur
    try {
      await OpenFile.open(path);
    } catch (e) {
      print("Erreur lors de l'ouverture du PDF: $e");
    }
  }


  Future<Uint8List> _generateQrImageData(List<PlatInfo> selectedPlats) async {  // génération du qrcode à partir de la liste des plats selctionnés
    final StringBuffer qrDataBuffer = StringBuffer();


    for (int i = 0; i < selectedPlats.length; i++) {  // on fait la chaine pour le qr code
      final plat = await _getPlatIngredients(selectedPlats[i].nom);  // appel de fonction qui recup tout les ingrédient du plat depuis bd
      if (plat != null) {
        final platData = {
          'nom': plat['nom'],
          'couleur': plat['couleur'],
          'ingredients': "",
          'emission':  plat['emission']
        };
        final platJson = jsonEncode(platData);  //on fait chaine au format json pour plus de lisibilité
        qrDataBuffer.write(platJson);
      }
    }

    final compressedData = utf8.encode(qrDataBuffer.toString());  // on compresse les donne (si on ne le fait pas le qrcode généré peut le pas être lisible)
    final compressedDataString = base64.encode(compressedData);

    final qrPainter = QrPainter(        // Création du QR code avec les données compressées

    data: compressedDataString,
      version: QrVersions.auto,
      gapless: true,
      color: Colors.black,
    );

    final qrCode = await qrPainter.toImageData(1200.0); // on donne une grande taille pour éviter bug qui coupe le qr code à la génération
    if (qrCode != null) {
      return Uint8List.fromList(qrCode.buffer.asUint8List());  // on retourne le qrcode
    } else {
      throw Exception("Erreur lors de la génération du QR code");
    }
  }




  Future<Uint8List> _generateQrUnique(PlatInfo selectedPlat,Color couleur) async {  // génération d'un qrcode de couleur'
    final StringBuffer qrDataBuffer = StringBuffer();


      final plat = await _getPlatIngredients(selectedPlat.nom);  // appel de fonction qui recup tout les ingrédient du plat depuis bd
      if (plat != null) {
        final platData = {
          'nom': plat['nom'],
          'couleur': plat['couleur'],
          'ingredients': plat['ingredients'],
          'emission': plat['emission']
        };
        final platJson = jsonEncode(platData);  //on fait chaine au format json pour plus de lisibilité
        qrDataBuffer.write(platJson);
      }


    final compressedData = utf8.encode(qrDataBuffer.toString());  // on compresse les donne (si on ne le fait pas le qrcode généré peut le pas être lisible)
    final compressedDataString = base64.encode(compressedData);

    final qrPainter = QrPainter(        // Création du QR code avec les données compressées

      data: compressedDataString,
      version: QrVersions.auto,
      gapless: true,
      color: couleur,
    );

    final qrCode = await qrPainter.toImageData(1200.0); // on donne une grande taille pour éviter bug qui coupe le qr code à la génération
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
