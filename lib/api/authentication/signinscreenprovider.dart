import 'package:flutter/material.dart';

class SignInScreenProvider extends ChangeNotifier {
  String userName = "";
  String password = "";
  String signInResponse = "";
  bool signingIn = false;

  void setUserName(String userName) {
    this.userName = userName;
    notifyListeners();
  }

  void updateSignInResponse(response) {
    signInResponse = response;
    notifyListeners();
  }

  void updateSigningInStatus(status) {
    signingIn = status;
    notifyListeners();
  }
}
