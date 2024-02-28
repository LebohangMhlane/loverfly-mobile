
import 'package:flutter/widgets.dart';
import 'package:loverfly/features/mainscreen/models/couple_model.dart';

class ViewCoupleProvider extends ChangeNotifier {
  bool pageLoading = true;
  Map couple = {};

  String partnerOnePicture = "";
  String partnerTwoPicture = "";
  String partnerOneUsername = "";
  String partnerTwoUsername = "";

  String anniversary = "";

  List coupleMemories = [];

  ViewCoupleProvider({required this.couple}) {
    if (couple.isNotEmpty) {
      CoupleModel coupleInstance = CoupleModel.createFromJson(couple);
      partnerOnePicture = couple["partner_one"]["profile_picture"]["image"];
      partnerTwoPicture = couple["partner_two"]["profile_picture"]["image"];

      partnerOneUsername = couple["partner_one"]["username"];
      partnerTwoUsername = couple["partner_two"]["username"];
      pageLoading = false;
      notifyListeners();
    }
  }
}
