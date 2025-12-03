import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentSelectedIndex;
  final Function(int)? onTap;
  const MyBottomNavigationBar({
    super.key,
    required this.currentSelectedIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentSelectedIndex,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 5,
      iconSize: 32,
      selectedItemColor: Colors.pinkAccent,
      unselectedItemColor: Theme.of(context).colorScheme.primary,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedFontSize: 14,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Trips'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
