
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:get/get.dart';
import 'package:loverfly/utils/utils.dart';

class Post {

  // required by the post object
  var postdatamap;
  var followeduserdata;

  Post({ this.postdatamap, this.followeduserdata });

  // injected dependency
  var utils = Get.put(DateFunctions());

  // post elements display functions
  String displaypostimage(){
    var postimage = '';
    postimage = postdatamap['image'];
    return postimage;
  }

  Map displaytimeposted(){
    var timeposted = {};
    timeposted = utils.convertdate(postdatamap['timeposted']);
    return timeposted;
  }

  String displaycaption(){
    var caption = '';
    caption = postdatamap['caption'];
    return caption;
  }

  Map displayprofilepictures(){
    var profilepictures = {
      "followeduser": followeduserdata['profilepicture'],
      "partner": jsonDecode(followeduserdata['partner_data'])['profilepicture'],
    };
    return profilepictures;
  }

  bool checkifverifiedcouple(){
    var isverified = true;
    return isverified;
  }

}