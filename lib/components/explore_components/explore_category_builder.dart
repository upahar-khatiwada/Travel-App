import 'package:flutter/material.dart';

class ExploreCategoryBuilder extends StatefulWidget {
  const ExploreCategoryBuilder({super.key});

  @override
  State<ExploreCategoryBuilder> createState() => _ExploreCategoryBuilderState();
}

class _ExploreCategoryBuilderState extends State<ExploreCategoryBuilder> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> categories = <Map<String, dynamic>>[
    <String, dynamic>{'icon': Icons.bed, 'label': 'Rooms'},
    <String, dynamic>{'icon': Icons.room_service, 'label': 'Icons'},
    <String, dynamic>{'icon': Icons.house, 'label': 'Homes'},
    <String, dynamic>{'icon': Icons.surfing, 'label': 'Surfing'},
    <String, dynamic>{'icon': Icons.person, 'label': 'Profile'},
    <String, dynamic>{'icon': Icons.person, 'label': 'Profile'},
    <String, dynamic>{'icon': Icons.person, 'label': 'Profile'},
    <String, dynamic>{'icon': Icons.person, 'label': 'Profile'},
    <String, dynamic>{'icon': Icons.person, 'label': 'Profile'},
    <String, dynamic>{'icon': Icons.person, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Positioned(
          left: 0,
          top: 82,
          right: 0,
          child: Divider(color: Colors.black12, thickness: 1),
        ),

        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => setState(() {
                  selectedIndex = index;
                }),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                      ),
                      child: Icon(
                        categories[index]['icon'],
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      categories[index]['label'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      height: 3,
                      width: selectedIndex == index ? 50 : 0,
                      color: selectedIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
