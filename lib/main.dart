import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database.dart';
import 'styles.dart';
import 'hub.dart';
import 'package:double_back_to_close/double_back_to_close.dart';


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
      debugShowCheckedModeBanner: false,
      title: 'CO2Score',
      theme: AppStyles.themeData,
      home:  DoubleBack(
        message: "Appuyez à nouveau pour quitter l'application",
        textStyle: TextStyle(fontSize: 17,color: Colors.white),
        child: hub(title: "CO2Score"),
      ),
    );
  }
}


