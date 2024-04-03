import 'package:flutter/material.dart';

class AppStyles {
  static ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.accentColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent, // Couleur transparente pour que la couleur de remplissage soit visible
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Arrondir les boutons
        ),
      ).merge(
        ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.secondaryColor; // Couleur de remplissage lorsqu'appuyé
              } else {
                return AppColors.secondaryColor.withOpacity(0.5); // Couleur de remplissage par défaut
              }
            },
          ),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0, // Supprimer l'ombre de l'app bar
      backgroundColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // Arrondir l'app bar
        ),
      ),
    ),
  );
}

class AppColors {
  static const Color primaryColor = Color(0xFF21BF65);
  static const Color secondaryColor = Color(0xFF04D94F);
  static const Color accentColor = Color(0xFF04BF45);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color lightGreen = Color(0xFFB6F2CB);
}
