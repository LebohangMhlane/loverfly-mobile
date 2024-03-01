import 'package:flutter/material.dart';
import 'package:loverfly/features/couple_explorer/api/couple_explorer_api.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/user_interactions/admire/admireapi.dart';

class CoupleExplorerProvider extends ChangeNotifier {
  List coupleList = [];
  List trendingCoupleList = [];
  List coupleCardProviders = [];
  bool pageLoading = true;
  bool initializationError = false;

  CoupleExplorerProvider(){
    print("initialization");
    initalizeProvider();
  }

  void initalizeProvider() async {
    try{
      var (successful, response) = await getAllCouples();
      if(successful){
        createProvidersForCouples(response);
      } else {
        Exception exception = response;
        throw exception;
      }
      pageLoading = false;
      notifyListeners();
    } catch (e){
      pageLoading = false;
      initializationError = true;
      notifyListeners();
      return;
    }
  }

  // TODO: consider returning a CoupleCardProvider in the listview.builder instead:

  void createProvidersForCouples(coupleInstanceList){
    for (int i = 0; i < coupleInstanceList.length; i++) {
      CoupleInstance coupleInstance = coupleInstanceList[i];
        coupleCardProviders.add(
        CoupleCardProvider(
          couple: coupleInstance.couple,
          isAdmired: coupleInstance.isAdmired,
        )
      );
    }
  }

  void refreshCoupleExplorerPage() async {
    coupleList = [];
    trendingCoupleList = [];
    coupleCardProviders = [];
    initalizeProvider();
  }

}

class CoupleCardProvider extends ChangeNotifier {
  Couple couple;
  bool isAdmired;
  bool admiring = false;
  int admirerCount = 0;

  CoupleCardProvider({
    required this.couple,
    required this.isAdmired,
  }) : admirerCount = couple.admirers;

  Future<bool> admireOrUnAdmireCouple() async {
    try {
      admiring = true;
      notifyListeners();
      Map response = await admire(couple.id, isAdmired);
      if (response.containsKey("error_info")) {
        admiring = false;
        notifyListeners();
        return false;
      } else {
        isAdmired = response["admired"];
        isAdmired ? admirerCount++ : admirerCount--;
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
