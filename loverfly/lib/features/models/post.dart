
import 'package:loverfly/features/models/couple.dart';

class PostApiResponse {

  bool isLiked = false;
  bool isAdmired = false;
  Post? post;
  Couple? couple;
  int commentCount = 0;
  bool isMyPost = false;

  PostApiResponse();

  PostApiResponse.createFromJson(Map json){
    isLiked = json["isLiked"];
    isAdmired = json["isAdmired"];
    post = Post.createFromJson(json["post"]);
    couple = Couple.createFromJson(json["couple"]);
    commentCount = json["comments_count"];
    isMyPost = json["is_my_post"];
  }

}

class Post {

  int id = 0;
  Couple? couple;
  String timePosted = "";
  String caption = "";
  String postImage = "";
  int likes = 0;
  bool deleted = false;
  String deletedDate = "";

  Post();

  Post.createFromJson(Map json){
    id = json["id"];
    couple = Couple.createFromJson(json["couple"]);
    timePosted = json["time_posted"];
    caption = json["caption"];
    postImage = json["post_image"];
    likes = json["likes"];
    deleted = json["deleted"];
    deletedDate = json["deleted_date"];
  }

}