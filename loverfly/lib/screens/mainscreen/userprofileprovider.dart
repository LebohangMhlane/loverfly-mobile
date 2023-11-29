import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  Map userProfile = {};

  void updateUserProfile(Map updatedUserProfile) {
    userProfile = updatedUserProfile;
    notifyListeners();
  }
}
