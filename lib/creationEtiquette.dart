import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as p;
import 'database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';

class GeneratePdfPage extends StatefulWidget {
  @override
  _GeneratePdfPageState createState() => _GeneratePdfPageState();
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  List<String> selectedPlats = [];
  List<Future<PdfColor>> couleursPlats = [];
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
                            couleursPlats.add(_getPlatColor(plat));
                          } else {
                            selectedPlats.remove(plat);
                            couleursPlats.remove(_getPlatColor(plat));
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
    List<PdfColor> colors = await Future.wait(couleursPlats);
    if (downloadsDirectory == null) {
      throw FileSystemException("Impossible d'accéder au répertoire de téléchargement.");
    }


    final pdf = p.Document();
    final qrImageData = await _generateQrImageData("Rougaille Saucisse,Rouge;huile olive,Vert;curcuma,Rouge;sel,vert;poivre,rouge;thym,vert;oignon,vert;tomate,vert;Saucisse de Montbéliard,Rouge;ail,vert;laurier,vert");

    pdf.addPage(
      p.Page(
        build: (context) {
          return p.Column(
            children: [
              p.Text("Menu du jour :"),
              for (var i = 0; i < selectedPlats.length; i++)
                p.Row(
                  children: [
                    p.Text(selectedPlats[i]),
                    p.Container(
                      width: 20,
                      height: 20,
                      decoration: p.BoxDecoration(
                        shape: p.BoxShape.circle,
                        color: colors[i],
                      ),
                    ),
                  ]
                ),
                p.SizedBox(height: 20),
                p.Text("détails du menu "),
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

    String path = '${downloadsDirectory.path}/menu.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    print("Chemin : " + path);
    return path;
  }

  Future<PdfColor?> _parseColor(String colorString) async {
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

  Future<PdfColor> _getPlatColor(String platName) async {
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

  void openPdfExternally(String path) async {
    try {
      await OpenFile.open(path);
    } catch (e) {
      print("Erreur lors de l'ouverture du PDF: $e");
    }
  }

  Future<Uint8List> _generateQrImageData(String data) async {
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    );
    final qrCode = await qrPainter.toImageData(200.0);
    if (qrCode != null) {
      return Uint8List.fromList(qrCode.buffer.asUint8List());
    } else {
      throw Exception("Erreur lors de la génération du QR code");
    }
  }

}
