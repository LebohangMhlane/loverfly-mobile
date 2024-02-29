import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/api/authentication/authenticationapi.dart';
import 'package:loverfly/environment_configurations/envconfig.dart';
import 'package:loverfly/features/view_couple/api/view_couple_api.dart';

class UserProfileProvider extends ChangeNotifier {
  Map userProfile = {};
  Map couple = {};
  bool loadingPage = true;
  String profilePicture = "https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg";
  String partnerProfilePicture = "https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg";
  bool showRelationshipStageOptions = false;
  List couplePosts = [];
  bool hasPosts = false;
  bool hasMessages = false;
  bool hasNotifications = true;

  UserProfileProvider() {
    initializeProvider();
  }

  void initializeProvider() async {
    prepareUserProfile(true);
  }

  void prepareUserProfile(bool notify) async {
    try {
      GetStorage cache = GetStorage();
      var auth = AuthenticationAPI();
      Map response = await auth.getUserProfileAndCoupleData(cache.read("token"));
      if (response.isNotEmpty) {
        userProfile = response["user_profile"];
        couple = response["couple"];
        cache.write("user_profile", jsonEncode(userProfile));
        cache.write("user_couple", jsonEncode(couple));
        profilePicture = userProfile["profile_picture"]["image"] == "" ? 
          EnvConfig.defaultProfilePicture : userProfile["profile_picture"]["image"]; 
        partnerProfilePicture = userProfile["my_partner"] != null ? userProfile["my_partner"]["profile_picture"]["image"] : EnvConfig.defaultProfilePicture;
        if(couple.isNotEmpty){
          hasPosts = await updateCouplePosts(couple["id"]);
        }
        loadingPage = false;
        notify ? notifyListeners() : null;
      }
    } catch (e) {
      loadingPage = false;
      notifyListeners();
    }
  }

  Future<bool> updateCouplePosts(coupleId) async {
    Map response = await getCouplePosts(coupleId);
    if(response["api_response"] != "failed"){
      couplePosts = response["couple_posts"];
      return true;
    }
    return false;
  }

}
