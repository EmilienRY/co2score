import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'scan.dart';
import 'database.dart';

void main() async {   //fonction main de l'app

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //  on verif si la bd existe
  final database = DatabaseHelper.instance;
  await database.initializeDatabase();

  //plat de test A SUPPRIMER PLUS TARD
  final plat1={
    'nom': 'Chili con carne',
    'couleur': 'rouge',
    'ingredients': 'Boeuf haché,Rouge;maïs,Vert;Oignons,Vert;Haricot rouge,Vert;Tomate,Vert'
  };

  final plat2={
    'nom': 'rougaille saucisse ',
    'couleur': 'rouge',
    'ingredients': 'huile olive,Vert;curcuma,Rouge;sel,vert;poivre,rouge;thym,vert;oignon,vert;tomate,vert;Saucisse de Montbéliard,Rouge;ail,vert;laurier,vert'
  };

  try{
    database.insertPlat(plat1);
    database.insertPlat(plat2);
  }
  catch(e){
    print('erreur lors insertion');
  }


  runApp(const MyApp());  //lance l'application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CO2Score',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CO2Score'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {   //page d'acceuil
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text('CO2 Score'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                controller?.pauseCamera();   // si on appuie sur bouton on met en pause caméra pour pas utiliser ressources pour rien
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pageMenu()),  // bouton pour aller vers page de la liste des menu
                ).then((value) {
                  controller?.resumeCamera();  // on lance la caméra
                });
              },
            ),
          ],
        ),
      ),
      body: Stack(   // lecteur de qr codes
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQrViewCreated,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(   // overlay pour voir ou scanner
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQrViewCreated(QRViewController controller) {   // fonction d'écoute
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageScan(scan: scanData.code!),  // si on a scan on va vers page de scan avec les données du qr code
        ),
      ).then((_) => controller.resumeCamera());
    });
  }

}
