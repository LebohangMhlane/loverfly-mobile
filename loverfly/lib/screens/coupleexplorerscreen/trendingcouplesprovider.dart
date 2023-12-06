import 'package:flutter/material.dart';
import 'package:loverfly/screens/coupleexplorerscreen/api/coupleexplorerapi.dart';

class TrendingCouplePageProvider extends ChangeNotifier {
  List trendingCouples = [];
  List trendingCoupleProviders = [];

  TrendingCouplePageProvider() {
    initializeProvider();
  }

  void initializeProvider() async {
    try {
      Map response = await getTrendingCouples();
      trendingCouples = response['trending_couples'];
      for (int i = 0; i < trendingCouples.length; i++) {
        Map couple = trendingCouples[i]["couple"];
        trendingCoupleProviders.add(TrendingCoupleProvider(
          coupleId: couple['id'],
          partnerOneProfilePic: couple["partner_one"]["profile_picture"] != null ? 
          couple["partner_one"]["profile_picture"]["image"] != "" ? 
          couple["partner_one"]["profile_picture"]["image"] : "" : "",
          partnerTwoProfilePic: couple["partner_two"]["profile_picture"] != null ? 
          couple["partner_two"]["profile_picture"]["image"] != "" ? 
          couple["partner_two"]["profile_picture"]["image"] : "" : "",
        ));
      }
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}

class TrendingCoupleProvider extends ChangeNotifier {
  int coupleId = 0;
  String partnerOneProfilePic = "";
  String partnerTwoProfilePic = "";

  TrendingCoupleProvider(
      {required this.coupleId,
      required this.partnerOneProfilePic,
      required this.partnerTwoProfilePic});
}
