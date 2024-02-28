import 'package:flutter/material.dart';
import 'package:loverfly/features/coupleexplorerscreen/api/coupleexplorerapi.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/userinteractions/admire/admireapi.dart';

class CoupleExplorerPageProvider extends ChangeNotifier {
  List coupleList = [];
  List trendingCoupleList = [];
  List coupleCardProviders = [];
  bool pageLoading = true;
  bool initializationError = false;

  CoupleExplorerPageProvider(){
    initalizeProvider();
  }

  void initalizeProvider() async {
    try{
      Map response = await getAllCouples();
      coupleList = response['couples'];
      createProvidersForCouples(coupleList);
      pageLoading = false;
      notifyListeners();
    } catch (e){
      pageLoading = false;
      initializationError = true;
      notifyListeners();
      return;
    }
  }

  void createProvidersForCouples(coupleList){
    for (int i = 0; i < coupleList.length; i++) {
      Couple couple = Couple.createFromJson(coupleList[i]["couple"]);
      coupleCardProviders.add(CoupleCardProvider(
        coupleId: int.parse(couple.id),
        isAdmired: false,
        partnerOneUsername: "",
        partnerTwoUsername: "",
        partnerOneProfilePic: "",
        partnerTwoProfilePic: "",
        admirersCount: 0
        )
      );
    }
  }

}

class CoupleCardProvider extends ChangeNotifier {
  int coupleId = 0;
  String partnerOneUsername = "";
  String partnerTwoUsername = "";
  String partnerOneProfilePic = "";
  String partnerTwoProfilePic = "";
  bool isAdmired = false;
  int admirersCount = 0;
  bool admiring = false;

  CoupleCardProvider({
    required this.coupleId,
    required this.partnerOneUsername,
    required this.partnerTwoUsername,
    required this.partnerOneProfilePic,
    required this.partnerTwoProfilePic,
    required this.isAdmired,
    required this.admirersCount,
  });

  Future<bool> admireOrUnAdmireCouple() async {
    try {
      admiring = true;
      notifyListeners();
      Map response = await admire(coupleId, isAdmired);
      if (response.containsKey("error_info")) {
        admiring = false;
        notifyListeners();
        return false;
      } else {
        isAdmired = response["admired"];
        isAdmired ? admirersCount++ : admirersCount--;
        admiring = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      admiring = false;
      notifyListeners();
      return false;
    }
  }

}
