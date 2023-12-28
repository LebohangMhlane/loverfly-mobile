import 'package:flutter/material.dart';

class CoupleProvider extends ChangeNotifier {
  String dates = "";
  List posts = [];
  String partnerOnePicture = "";
  String partnerTwoPicture = "";
  String numberOfAdmirers = "";
  String startDate = "";
  String nextAnniversary = "";
  bool pageLoading = true;

  void getCouplePosts(coupleId) {}
}
