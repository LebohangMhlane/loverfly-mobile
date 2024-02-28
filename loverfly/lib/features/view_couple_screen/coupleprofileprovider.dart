import 'package:flutter/widgets.dart';

class ViewCoupleProvider extends ChangeNotifier {
  bool pageLoading = true;
  Map couple = {};

  String partnerOnePicture = "";
  String partnerTwoPicture = "";
  String partnerOneUsername = "";
  String partnerTwoUsername = "";

  String anniversary = "";

  List coupleMemories = [];

  // TODO: create models for all responses:

  ViewCoupleProvider({required this.couple}) {
    if (couple.isNotEmpty) {
      partnerOnePicture = couple["partner_one"]["profile_picture"]["image"];
      partnerTwoPicture = couple["partner_two"]["profile_picture"]["image"];

      partnerOneUsername = couple["partner_one"]["username"];
      partnerTwoUsername = couple["partner_two"]["username"];
      pageLoading = false;
      notifyListeners();
    }
  }
}
