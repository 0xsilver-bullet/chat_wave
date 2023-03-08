import 'package:flutter/material.dart';

abstract class AppColors {
  static const textGrey = Color(0xFF939393);
}

abstract class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: Colors.black,
        fontFamily: 'Montserrat',
        fontSize: 14,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: Colors.white,
        fontFamily: 'Montserrat',
        fontSize: 14,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );
}
