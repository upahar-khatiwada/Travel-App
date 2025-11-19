import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsSelectedProvider extends ChangeNotifier {
  int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  static TabsSelectedProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<TabsSelectedProvider>(context, listen: listen);
  }
}
