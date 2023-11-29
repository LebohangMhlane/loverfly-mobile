import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  List posts = [];
  bool postsFound = false;
  int pageIndex = 0;
  String paginationLink = "";
  Map couple = {};
  bool showExitModal = false;
  bool loadingPage = true;

  void updatePaginationLink(newPaginationLink) {
    paginationLink = newPaginationLink;
    notifyListeners();
  }

  void updatePosts(newPosts) {
    posts = newPosts;
    notifyListeners();
  }

  void updatePostsFound(bool werePostsFound) {
    postsFound = werePostsFound;
    notifyListeners();
  }

  void updatePageLoading(bool isLoading) {
    loadingPage = isLoading;
    notifyListeners();
  }
}
