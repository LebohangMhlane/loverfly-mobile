import 'package:flutter/material.dart';
import 'package:loverfly/screens/mainscreen/api/mainscreenapi.dart';

class MainPageProvider extends ChangeNotifier {
  Map mainScreenData = {
    "posts": [],
    "postsFound": false,
    "pageIndex": 0,
    "paginationLink": "",
    "couple": {},
    "showExitModal": false,
    "loadingPage": true
  };

  bool initializationError = false;
  List posts = [];
  List postProviders = [];

  MainPageProvider() {
    initializeProvider();
  }

  void initializeProvider() async {
    try {
      Map response = await getPostsForFeed("");
      posts = response["posts"];
      createProvidersForPosts(posts);
    } catch (e) {
      initializationError = true;
      notifyListeners();
    }
  }

  void createProvidersForPosts(posts) {
    for (int i = 0; i < posts.length; i++) {
      Map post = posts[i];
      postProviders.add(
        PostProvider(
          post: post["post"],
          coupleAdmired: post["isAdmired"],
          isLiked: post["isLiked"],
          couple: post["couple"],
          commentCount: post["comments_count"],
          isMyPost: post["is_my_post"],
        )
      );
    }
  }

  void updateValue(String key, dynamic value) {
    mainScreenData[key] = value;
    notifyListeners();
  }

}

class PostProvider extends ChangeNotifier {
  bool isLiked = false;
  bool coupleAdmired = false;
  int commentCount = 0;
  bool isMyPost = false;
  Map post = {};
  Map couple = {};

  PostProvider(
      {
      required this.post,
      required this.isLiked,
      required this.coupleAdmired,
      required this.commentCount,
      required this.isMyPost,
      required this.couple,
      });
      
}
