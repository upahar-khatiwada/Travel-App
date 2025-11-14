import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Color(0xFF717171),
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    inversePrimary: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Color(0xFF717171),
    showUnselectedLabels: true,
  ),
  useMaterial3: true,
);