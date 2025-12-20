import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/screens/screens.dart';

class ExploreSearchBar extends StatefulWidget {
  const ExploreSearchBar({super.key});

  @override
  State<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends State<ExploreSearchBar> {
  final CollectionReference<Map<String, dynamic>> placesCollection =
      FirebaseFirestore.instance.collection('CollectionOfPlaces');

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _suggestions =
      <QueryDocumentSnapshot<Map<String, dynamic>>>[];

  Future<void> _fetchPlaces() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await placesCollection
        .get();

    setState(() {
      _suggestions = snapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 4,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
                borderRadius: BorderRadius.circular(35),
                border: BoxBorder.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Where to?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            height: 25,
                            child: RawAutocomplete<String>(
                              optionsViewBuilder:
                                  (
                                    BuildContext context,
                                    void Function(String) onSelected,
                                    Iterable<String> options,
                                  ) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 6,
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: 250,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: options.length,
                                            itemBuilder:
                                                (
                                                  BuildContext context,
                                                  int index,
                                                ) {
                                                  final String option = options
                                                      .elementAt(index);
                                                  return ListTile(
                                                    title: Text(option),
                                                    onTap: () =>
                                                        onSelected(option),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                              optionsBuilder: (TextEditingValue value) {
                                if (value.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }

                                return _suggestions
                                    .map(
                                      (
                                        QueryDocumentSnapshot<
                                          Map<String, dynamic>
                                        >
                                        doc,
                                      ) => doc['title'] as String,
                                    )
                                    .where(
                                      (String option) => option
                                          .toLowerCase()
                                          .contains(value.text.toLowerCase()),
                                    );
                              },
                              onSelected: (String selection) {
                                final QueryDocumentSnapshot<
                                  Map<String, dynamic>
                                >
                                selectedDoc = _suggestions.firstWhere(
                                  (
                                    QueryDocumentSnapshot<Map<String, dynamic>>
                                    doc,
                                  ) => doc['title'] == selection,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute<Widget>(
                                    builder: (_) => ExploreDetailPage(
                                      currentSelectedPlaceData: selectedDoc,
                                    ),
                                  ),
                                );
                              },
                              fieldViewBuilder:
                                  (
                                    BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    void Function() onFieldSubmitted,
                                  ) {
                                    return TextField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        hintText:
                                            'Anywhere · Any week · Add guests',
                                        hintStyle: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    );
                                  },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsGeometry.only(left: 10, right: 5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: BoxBorder.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.tune,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
