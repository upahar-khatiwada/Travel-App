import 'package:flutter/material.dart';
import 'package:travel_app/components/components.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: UnFocusOnTap(
        child: Scaffold(
          body: Column(
            children: <Widget>[ExploreSearchBar(), ExploreCategoryBuilder()],
          ),
        ),
      ),
    );
  }
}
