import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:travel_app/components/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSelectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = const <Widget>[
      ExplorePage(),
      FavoritesPage(),
      TripsPage(),
      MessagesPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
        currentSelectedIndex: _currentSelectedIndex,
        onTap: (int index) {
          setState(() {
            _currentSelectedIndex = index;
          });
        },
      ),
      body: pages[_currentSelectedIndex],
    );
  }
}
