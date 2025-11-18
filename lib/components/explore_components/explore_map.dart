import 'package:flutter/material.dart';

class ExploreMapWidget extends StatelessWidget {
  const ExploreMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {
        // showModalBottomSheet(context: context, builder: builder)
      },
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.inversePrimary,
              blurRadius: 5,
            ),
          ],
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          spacing: 3,
          children: <Widget>[
            Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 20,
            ),
            Text(
              'Map',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
