import 'package:flutter/material.dart';
import 'package:loverfly/environmentconfig/envconfig.dart';
import 'package:loverfly/features/main_screen/api/mainscreenapi.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/features/models/post.dart';
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
        PostApiResponse postApiResponse = PostApiResponse.createFromJson(posts[i]);
        Post? post = postApiResponse.post;
        postProviders.add(PostProvider(
          post: post!,
          isAdmired: postApiResponse.isAdmired,
          isLiked: postApiResponse.isLiked,
          couple: post.couple!,
          isMyPost: postApiResponse.isMyPost,
          commentCount: postApiResponse.commentCount.toString(),
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
  Couple? couple;
  Post? post;

  PostProvider({
    required this.isLiked,
    required this.isMyPost,
    required this.couple,
    required this.post,
    required this.isAdmired,
    required this.commentCount,
  }) {
    try {
      profilePictureOne = post!.couple!.partnerOne!.profilePicture;
      profilePictureTwo = post!.couple!.partnerTwo!.profilePicture;
      userNameOne = post!.couple!.partnerOne!.username;
      userNameTwo = post!.couple!.partnerTwo!.username;
      admirerCount = post!.couple!.admirers.toString();
      likeCount = post!.likes.toString();
      postImage = post!.postImage;
      commentCount = 0.toString(); // TODO: fix later:
      date = DateFunctions().convertdate(post!.timePosted);
      post = post;
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
    if (isLiked) {
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
