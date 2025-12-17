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
                      displayTotalPriceSwitch(context),
                      ExplorePlacesBuilder(categoryFilter: selectedCategory),
                    ],
                  ),
                ),
              ),

              // for displaying the actual places
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const ExploreMapWidget(),
        ),
      ),
    );
  }

  Container displayTotalPriceSwitch(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: BoxBorder.all(color: Theme.of(context).colorScheme.tertiary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: <Widget>[
              Text(
                'Display total price',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Includes all fees, before taxes',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),

          Switch(
            value: isSwitchOnForDisplayingTotalPrice,
            onChanged: (bool changedValue) {
              setState(() {
                isSwitchOnForDisplayingTotalPrice = changedValue;
              });
            },
            trackOutlineColor: WidgetStatePropertyAll<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
            trackOutlineWidth: const WidgetStatePropertyAll<double>(1),
            inactiveThumbColor: Theme.of(context).colorScheme.inversePrimary,
            inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
