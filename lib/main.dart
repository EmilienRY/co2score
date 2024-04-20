import 'package:co2score/pageScan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'database.dart';
import 'creationEtiquette.dart';
import 'CreationPlat.dart';

void main() async {   //fonction main de l'app

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //  on verif si la bd existe
  final database = DatabaseHelper.instance;
  await database.initializeDatabase();

  runApp(const MyApp());  //lance l'application
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
GlobalKey<NavigatorState> scanPageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> menuPageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> platPageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> etiquettePageKey = GlobalKey<NavigatorState>();

class _MyHomePageState extends State<MyHomePage> {
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
  ];



  @override
    Widget build(BuildContext context) {   //page d'accueil
      return Scaffold(
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
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(qr_code_scanner),label: "scan"),
                  BottomNavigationBarItem(icon: Icon(chrome_reader_mode),label: "menu"),
                  BottomNavigationBarItem(icon: Icon(restaurant_menu),label: "plat"),
                  BottomNavigationBarItem(icon: Icon(article),label: "étiquette"),
                ],
                currentIndex: _currentIndex,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                backgroundColor: Color(0xFFB6F2CB),
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

      );
    }

    static const IconData chrome_reader_mode = IconData(0xe162, fontFamily: 'MaterialIcons', matchTextDirection: true);
    static const IconData restaurant_menu = IconData(0xe533, fontFamily: 'MaterialIcons');
    static const IconData qr_code_scanner = IconData(0xe4f7, fontFamily: 'MaterialIcons');
    static const IconData article = IconData(0xe0a2, fontFamily: 'MaterialIcons');


    void _onItemTapped(int index) {
      setState(() {

        if (_currentIndex != index) {
          _currentIndex=index;
        }
      });
    }

}
