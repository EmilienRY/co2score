import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'scan.dart';


class pageScan extends StatefulWidget {
  @override
  _GeneratepageScanState createState() => _GeneratepageScanState();
}

class _GeneratepageScanState extends State<pageScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;



  @override
  Widget build(BuildContext context) {   //page d'accueil
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text('CO2 Score'),

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
