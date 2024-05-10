import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromRGBO(45, 45, 45, 1);
  static Color primaryAccent = const Color.fromRGBO(35, 35, 35, 1);
  static Color secondaryColor = const Color.fromRGBO(255, 231, 120, 1);
  static Color secondaryAccent = const Color.fromRGBO(255, 190, 82, 1);
  static Color titleColor = const Color.fromRGBO(200, 200, 200, 1);
  static Color textColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color successColor = const Color.fromRGBO(9, 149, 110, 1);
  static Color highlightColor = const Color.fromRGBO(212, 172, 13, 1);
  static Color buttonColor = const Color.fromRGBO(255, 127, 0, 1);
  static Color textBackgroundColor = const Color.fromRGBO(55, 55, 55, 1);
}

ThemeData primaryTheme = ThemeData(

  // seed color theme
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
  ),

  // scaffold color
  scaffoldBackgroundColor: AppColors.primaryColor,

  // app bar theme colors
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryAccent,
    foregroundColor: AppColors.textColor,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),

  // text theme
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 1,
    ),
    headlineMedium: TextStyle(
      color: AppColors.titleColor, 
      fontSize: 16,
      fontWeight: FontWeight.bold, 
      letterSpacing: 1,
    ),
    titleMedium: TextStyle(
      color: AppColors.titleColor, 
      fontSize: 18, 
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  ),

  // card theme
  cardTheme: CardTheme(
    color: AppColors.secondaryColor.withOpacity(0.5),
    surfaceTintColor: Colors.transparent,
    shape: const RoundedRectangleBorder(),
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.only(bottom: 16),
  ),

  // input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.textBackgroundColor.withOpacity(0.5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    labelStyle: TextStyle(color: AppColors.textColor),
    prefixIconColor: AppColors.textColor,
    
    
  ),

  // dialog theme
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.secondaryAccent,
    surfaceTintColor: AppColors.secondaryAccent,
  ),

);