import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final GlobalKey qrKey= GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  
  @override
  void reassemble(){
    super.reassemble();
    controller!.resumeCamera();

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget> [
        Expanded(
          flex: 5,
          child: QRView(key: qrKey, onQRViewCreated: _onQrViewCreated)
        ),
        Expanded(
            flex: 1,
          child: Center(
              child: (result != null) ? Text("Barcode Type: ${result!.format.name} Data: ${result!.code} ") : const Text("Scan a code")
            ),
        )
      ],),
    );
  }
  
  void _onQrViewCreated(QRViewController controller){
    this.controller=controller;
    controller.scannedDataStream.listen((scanData) { 
      setState(() {
        result=scanData;
      });
    });
  }
  
  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
  
}
