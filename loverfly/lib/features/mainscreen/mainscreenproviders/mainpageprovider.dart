import 'package:flutter/material.dart';
import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:loverfly/features/mainscreen/api/mainscreenapi.dart';
import 'package:loverfly/utils/utils.dart';

class MainPageProvider extends ChangeNotifier {
  bool initializationError = false;
  List posts = [];
  List postProviders = [];
  String paginationLink = "";
  bool loadingPage = true;

  MainPageProvider() {
    initializeProvider();
  }

  void initializeProvider() async {
    try {
      Map response = await getPostsForFeed("");
      posts = response["posts"];
      if (createProvidersForPosts(posts)) {
        loadingPage = false;
        notifyListeners();
      } else {
        initializationError = true;
        loadingPage = false;
        notifyListeners();
      }
    } catch (e) {
      initializationError = true;
      notifyListeners();
    }
  }

  bool createProvidersForPosts(posts) {
    try {
      for (int i = 0; i < posts.length; i++) {
        Map post = posts[i];
        postProviders.add(PostProvider(
          post: post,
          isAdmired: post["isAdmired"],
          isLiked: post["isLiked"],
          couple: post["couple"],
          isMyPost: post["is_my_post"],
        ));
      }
      return true;
    } catch (e) {
      return false;
    }
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
      profilePictureOne = couple["partner_one"]["profile_picture"]["image"] != "" ? 
      couple["partner_one"]["profile_picture"]["image"] : EnvConfig().defaultProfilePicture;
      profilePictureTwo = couple["partner_two"]["profile_picture"]["image"] != "" ? 
      couple["partner_two"]["profile_picture"]["image"] : EnvConfig().defaultProfilePicture;
      userNameOne = couple["partner_one"]["username"];
      userNameTwo = couple["partner_two"]["username"];
      admirerCount = couple["admirers"].toString();
      likeCount = post["post"]["likes"].toString();
      postImage = post["post"]["post_image"];
      commentCount = post["comments_count"].toString();
      date = DateFunctions().convertdate(post["post"]["time_posted"]);
    } catch (e) {
      print(e);
      null;
    }
  }

  void updateIsAdmired(isAdmired) {
    this.isAdmired = isAdmired;
    int newAdmirerCount = int.parse(admirerCount);
    if (isAdmired) {
      newAdmirerCount++;
      admirerCount = newAdmirerCount.toString();
      notifyListeners();
    } else {
      newAdmirerCount--;
      admirerCount = newAdmirerCount.toString();
      notifyListeners();
    }
  }

  void updateLikes(isLiked) {
    this.isLiked = isLiked;
    int newLikeCount = int.parse(likeCount);
    if (isAdmired) {
      newLikeCount++;
      likeCount = newLikeCount.toString();
      notifyListeners();
    } else {
      newLikeCount--;
      likeCount = newLikeCount.toString();
      notifyListeners();
    }
  }

}
