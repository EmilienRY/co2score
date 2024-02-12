import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'menu.dart';

void main() {   //fonction main de l'app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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

  //mettre variables réutilisés après ici

  final GlobalKey qrKey= GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;


  @override
  Widget build(BuildContext context){   //fonction de création de la page, rajouter des choses ici si on veut modif ce à quoi ressemble la page
    return Scaffold(

        appBar: PreferredSize(     //bar du haut
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: Colors.green,    //changer couleur
            centerTitle: true,
            title: const Text('CO2 Score'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add), //A CHANGER
                onPressed: () {
                  controller?.pauseCamera(); // arréter la cam quand on change de page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pageMenu()), // passe à la page avec la liste de tout les plats
                  ).then((value) {

                    controller?.resumeCamera();  // Reprendre la cam quand on va sur cette page
                  });
                },
              ),
            ],
          ),
        ),


      body: Column(
        children: <Widget> [

          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQrViewCreated)   //emplacement du scanner QRcode
          ),
          Expanded(
              flex: 1,
            child: Center(
                child: (result != null) ? Text("Barcode Type: ${result!.format.name} Data: ${result!.code} ") : const Text("Scan a code")  // affiche les valeurs scan pour le moment
              ),
        )
      ],),

    );
  }
  
  void _onQrViewCreated(QRViewController controller){   //vonction qui initialize le scanner et passe en écoute. Stocke valeur du scan dans variable result
    this.controller=controller;
    controller.scannedDataStream.listen((scanData) { 
      setState(() {
        result=scanData;
      });
    });
  }

  @override
  void reassemble(){
    super.reassemble();
    controller!.resumeCamera();

  }
  
  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
  
}
