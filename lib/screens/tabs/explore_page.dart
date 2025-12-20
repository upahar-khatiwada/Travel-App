import 'package:flutter/material.dart';
import 'package:travel_app/components/components.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String selectedCategory = 'All';
  bool isSwitchOnForDisplayingTotalPrice =
      false; // the total price displaying switch

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: UnFocusOnTap(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              // for the first search bar
              const ExploreSearchBar(),

              // for the categories scroller
              ExploreCategoryBuilder(
                onCategorySelected: (String category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),

              // for the total price display
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ExplorePlacesBuilder(categoryFilter: selectedCategory),
                    ],
                  ),
                ),
              ),

              // for displaying the actual places
            ],
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: const ExploreMapWidget(),
        ),
      ),
    );
  }
}