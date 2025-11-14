import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Color(0xFFB0B0B0),
    onSecondary: Colors.black,
    surface: Color(0xFF121212),
    onSurface: Colors.white,
    inverseSurface: Colors.black
  ),
  scaffoldBackgroundColor: const Color(0xFF000000),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF121212),
    selectedItemColor: Colors.white,
    unselectedItemColor: Color(0xFFB0B0B0),
    showUnselectedLabels: true,
  ),
  useMaterial3: true,
);