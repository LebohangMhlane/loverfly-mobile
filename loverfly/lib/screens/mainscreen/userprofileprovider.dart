import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/api/authentication/authenticationapi.dart';
import 'package:loverfly/screens/couplescreen/api/couplescreenapi.dart';

class UserProfileProvider extends ChangeNotifier {
  Map userProfile = {};
  Map couple = {};
  bool loadingPage = true;
  String profilePicture = "https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg";
  String partnerProfilePicture = "https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg";
  bool showRelationshipStageOptions = false;
  List couplePosts = [];

  UserProfileProvider() {
    initializeProvider();
  }

  void initializeProvider() async {
    updateUserProfile(true);
    updateCouplePosts(couple["id"]);
  }

  void updateUserProfile(bool notify) async {
    try {
      GetStorage cache = GetStorage();
      var auth = AuthenticationAPI();
      Map response = await auth.getUserProfileAndCoupleData(cache.read("token"));
      if (response.isNotEmpty) {
        userProfile = response["user_profile"];
        couple = response["couple"];
        cache.write("user_profile", jsonEncode(userProfile));
        cache.write("user_couple", jsonEncode(couple));
        profilePicture = userProfile["profile_picture"]["image"]; // TODO: set the default image in the back end so we don't have to do checks for null here:
        partnerProfilePicture = userProfile["my_partner"]["profile_picture"]["image"];
        await updateCouplePosts(couple["id"]);
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
    print(response);
    return true;
  }

}
