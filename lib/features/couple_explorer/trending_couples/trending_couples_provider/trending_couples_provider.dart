import 'package:flutter/material.dart';
import 'package:loverfly/features/couple_explorer/api/couple_explorer_api.dart';
import 'package:loverfly/features/models/couple.dart';

class TrendingCouplesWidgetProvider extends ChangeNotifier {
  List trendingCouples = [];
  List trendingCoupleProviders = [];
  bool initializationError = false;

  TrendingCouplesWidgetProvider() {
    initializeProvider();
  }

  void initializeProvider() async {
    try {
      Map response = await getTrendingCouples();
      trendingCouples = response['trending_couples'];
      for (int i = 0; i < trendingCouples.length; i++) {
        Couple couple = Couple.createFromJson(trendingCouples[i]["couple"]);
        trendingCoupleProviders.add(
          TrendingCoupleProvider(
            couple: couple,
            partnerOneProfilePic: couple.partnerOne!.profilePicture,
            partnerTwoProfilePic: couple.partnerTwo!.profilePicture
          )
        );
      }
      notifyListeners();
    } catch (e) {
      initializationError = true;
      notifyListeners();
      return;
    }
  }
}

class TrendingCoupleProvider extends ChangeNotifier {
  Couple couple;
  String partnerOneProfilePic;
  String partnerTwoProfilePic;

  TrendingCoupleProvider({
    required this.couple,
    required this.partnerOneProfilePic,
    required this.partnerTwoProfilePic
  });
}
