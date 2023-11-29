import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  Map mainScreenData = {
    "posts": [],
    "postsFound": false,
    "pageIndex": 0,
    "paginationLink": "",
    "couple": {},
    "showExitModal": false,
    "loadingPage": true
  };

  void updateValue(String key, dynamic value) {
    mainScreenData[key] = value;
    notifyListeners();
  }
}
