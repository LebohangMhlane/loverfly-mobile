

import 'package:loverfly/features/mainscreen/models/couple_model.dart';

class PostResponse {

  bool? isLiked;
  bool? isAdmired;
  Post? post;
  CoupleModel? couple;
  int? commentCount;
  bool? isMyPost;

  PostResponse.createFromJson(Map json){
    isLiked = json["isLiked"];
    isAdmired = json["isAdmired"];
    post = Post.createFromJson(json["post"]);
    couple = CoupleModel.createFromJson(json["couple"]);
    commentCount = json["comments_count"];
    isMyPost = json["is_my_post"];
  }

}

class Post {

  int? id;
  CoupleModel? couple;
  String? timePosted;
  String? caption;
  String? postImage;
  int? likes;
  bool? deleted;
  String? deletedDate;

  Post.createFromJson(Map json){
    id = json["id"];
    couple = CoupleModel.createFromJson(json["couple"]);
    timePosted = json["time_posted"];
    caption = json["caption"];
    postImage = json["post_image"];
    likes = json["likes"];
    deleted = json["deleted"];
    deletedDate = json["deletedDate"];
  }

}