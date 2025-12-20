import 'package:flutter/material.dart';
import 'package:travel_app/provider/tabs_selected_provider.dart';
import 'screens.dart';
import 'package:travel_app/components/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = const <Widget>[
      ExplorePage(),
      FavoritesPage(),
      DiscoverPage(),
      MessagesPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final TabsSelectedProvider provider = TabsSelectedProvider.of(context);

    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
        currentSelectedIndex: provider.currentIndex,
        onTap: (int index) {
          provider.setIndex(index);
        },
      ),
      body: pages[provider.currentIndex],
    );
  }
}
