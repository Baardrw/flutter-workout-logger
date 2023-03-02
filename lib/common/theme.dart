import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: MaterialColor(
    const Color.fromARGB(255, 51, 100, 140).value,
    const <int, Color>{
      50: Color.fromRGBO(51, 100, 140, 0.1),
      100: Color.fromRGBO(51, 100, 140, 0.2),
      200: Color.fromRGBO(51, 100, 140, 0.3),
      300: Color.fromRGBO(51, 100, 140, 0.4),
      400: Color.fromRGBO(51, 100, 140, 0.5),
      500: Color.fromRGBO(51, 100, 140, 0.6),
      600: Color.fromRGBO(51, 100, 140, 0.7),
      700: Color.fromRGBO(51, 100, 140, 0.8),
      800: Color.fromRGBO(51, 100, 140, 0.9),
      900: Color.fromRGBO(51, 100, 140, 1.0),
    },
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 51, 100, 140),
    titleTextStyle: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: Colors.white,
    ),
  ),
  backgroundColor: Colors.white,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
    displayLarge: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: Colors.black,
    ),
  ),
  buttonColor: Colors.amber,
);
