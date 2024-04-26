import 'package:co2score/pageScan.dart';
import 'package:flutter/material.dart';
import 'menu.dart';
import 'creationEtiquette.dart';
import 'CreationPlat.dart';
import 'styles.dart';
import 'pageCom.dart';


class hub extends StatefulWidget {
  const hub({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<hub> createState() => _hubState();
}

GlobalKey<NavigatorState> scanPageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> menuPageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> platPageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> etiquettePageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> etiquettePageCom = GlobalKey<NavigatorState>();

class _hubState extends State<hub> {
  int _currentIndex = 0;




  List<Widget> _widgetOptions = <Widget>[
    Navigator(
      key: scanPageKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => pageScan(),
        );
      },
    ),
    Navigator(
      key: menuPageKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => pageMenu(),
        );
      },
    ),
    Navigator(
      key: platPageKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => pageCreation(),
        );
      },
    ),
    Navigator(
      key: etiquettePageKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => GeneratePdfPage(),
        );
      },
    ),
    Navigator(
      key: etiquettePageCom,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => pageCom(),
        );
      },
    ),
  ];



  @override
  Widget build(BuildContext context) {   //page d'accueil
    return MaterialApp(
      theme: AppStyles.themeData,
      home : Scaffold(
        extendBody: true,
        bottomNavigationBar:

        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child:  BottomNavigationBar(
                //type: BottomNavigationBarType.fixed,
                backgroundColor: Color(0xFFB6F2CB),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(qr_code_scanner),label: "scan"),
                  BottomNavigationBarItem(icon: Icon(chrome_reader_mode),label: "menu"),
                  BottomNavigationBarItem(icon: Icon(restaurant_menu),label: "plat"),
                  BottomNavigationBarItem(icon: Icon(article),label: "étiquette"),
                  BottomNavigationBarItem(icon: Icon(cell_wifi),label: "pageMonde"),
                ],
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
              ),
            )
        )
        ,
        body: Navigator(
          onGenerateRoute: (settings) {

            return MaterialPageRoute(
              builder: (context) => _widgetOptions[_currentIndex],
            );
          },
        ),

      ),

    );
  }

  static const IconData chrome_reader_mode = IconData(0xe162, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData restaurant_menu = IconData(0xe533, fontFamily: 'MaterialIcons');
  static const IconData qr_code_scanner = IconData(0xe4f7, fontFamily: 'MaterialIcons');
  static const IconData article = IconData(0xe0a2, fontFamily: 'MaterialIcons');
  static const IconData cell_wifi = IconData(0xe14a, fontFamily: 'MaterialIcons');


  void _onItemTapped(int index) {
    setState(() {

      if (_currentIndex != index) {
        _currentIndex=index;
      }
    });
  }

}
