import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/themes/themes.dart';

class ThemeProvider with ChangeNotifier {
  final Box<dynamic> themeBox = Hive.box('travel_theme');

  // default theme is light theme
  ThemeData _themeData = lightTheme;

  // constructor to read the saved theme from local device
  ThemeProvider() {
    final bool? isDark = themeBox.get('isDarkMode', defaultValue: false);

    // set the theme mode as per the theme read from the device
    _themeData = isDark! ? darkTheme : lightTheme;
  }

  // getter for theme data
  ThemeData get themeData => _themeData;

  // getter for dark mode for settings page
  bool get isDarkMode => _themeData == darkTheme;

  // setter to set the theme data from toggleTheme() method
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    themeBox.put('isDarkMode', themeData == darkTheme);
    notifyListeners();
  }

  ThemeMode? get themeMode =>
      _themeData == darkTheme ? ThemeMode.dark : ThemeMode.light;

  // function to toggle the theme
  void toggleTheme() async {
    themeData = (_themeData == lightTheme) ? darkTheme : lightTheme;
  }

    static ThemeProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<ThemeProvider>(context, listen: listen);
  }
}
