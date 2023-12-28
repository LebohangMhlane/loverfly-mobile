import 'package:flutter/material.dart';
import 'package:loverfly/screens/mainscreen/api/mainscreenapi.dart';
import 'package:loverfly/utils/utils.dart';

class MainPageProvider extends ChangeNotifier {
  Map mainPageData = {
    "posts": [],
    "postsFound": false,
    "pageIndex": 0,
    "paginationLink": "",
    "couple": {},
    "showExitModal": false,
    "loadingPage": true,
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
      postProviders.add(PostProvider(
        post: post["post"],
        isAdmired: post["isAdmired"],
        isLiked: post["isLiked"],
        couple: post["couple"],
        isMyPost: post["is_my_post"],
      ));
    }
  }

  void updateAValue(String key, dynamic value) {
    mainPageData[key] = value;
    notifyListeners();
  }
}

class PostProvider extends ChangeNotifier {
  String profilePictureOne = "";
  String profilePictureTwo = "";
  String userNameOne = "";
  String userNameTwo = "";
  String admirerCount = "";
  String postImage = "";
  Map date = {};
  String likeCount = "";
  bool isAdmired = false;
  bool isLiked = false;
  String commentCount = "";
  bool isMyPost = false;
  Map couple = {};
  Map post = {};

  PostProvider({
    required this.isLiked,
    required this.isMyPost,
    required this.couple,
    required this.post,
    required this.isAdmired,
  }) {
    try {
      profilePictureOne = couple["partner_one"]["profile_picture"]["image"];
      profilePictureTwo = couple["partner_two"]["profile_picture"]["image"];
      userNameOne = couple["partner_one"]["username"];
      userNameTwo = couple["partner_two"]["username"];
      admirerCount = couple["admirers"].toString();
      likeCount = post["likes"].toString();
      postImage = post["post_image"];
      commentCount = post["comments_count"].toString();
      date = DateFunctions().convertdate(post["time_posted"]);
    } catch (e) {
      null;
    }
  }
}
