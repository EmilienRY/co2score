import 'package:flutter/material.dart';

// on définit ici le style des différents éléments de l'application

class AppStyles {
  // Couleurs
  static const Color primaryColor = Color(0xFF21BF65);
  static const Color secondaryColor = Color(0xFF04D94F);
  static const Color accentColor = Color(0xFF04BF45);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color lightGreen = Color(0xFFB6F2CB);

  // Thèmes
  static ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    //accentColor: accentColor,
    backgroundColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // Ajustez le rayon selon vos préférences
        ),
      ),

    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Ajustez la valeur pour définir la rondeur de la bordure
      ),

    ),


    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: secondaryColor,
      unselectedItemColor: lightGreen,
    ),



    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ),

    listTileTheme:ListTileThemeData(
      dense: false,
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),


  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(150, 50)),
        backgroundColor: MaterialStateProperty.all(secondaryColor),
        foregroundColor: MaterialStateProperty.all(lightGreen),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),



    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    ),


  );

  // Style pour la ListView
  static const double listItemMargin = 8.0;
}
