// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/screens/coupleexplorerscreen/viewcouplecard.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import '../../components/customappbar.dart';
import 'api/coupleexplorerapi.dart';
import 'trendingcouplessection.dart';

class CoupleExplorerScreen extends StatelessWidget {
  CoupleExplorerScreen({
    Key? key,
  }) : super(key: key);

  final Rx<List> trendingCouplesList = Rx([]);
  final Rx<List> couples = Rx([]);

  @override
  Widget build(BuildContext context) {
    preparePageData(true);

    return WillPopScope(
      onWillPop: () {
        Get.off(() => MainScreen());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: customAppBar(context, 'Couple Explorer'),
        body: Obx(() => Column(
              children: [
                TrendingCouples(
                  trendingCouplesList: trendingCouplesList.value,
                  rebuildCoupleExplorer: preparePageData,
                ),

                // couples:
                Expanded(
                  flex: 5,
                  child: Container(
                    child: ListView.builder(
                        itemCount: couples.value.length,
                        itemBuilder: (context, index) {
                          // couple card:
                          return CoupleCard(
                            coupleData: couples.value[index],
                            rebuildCoupleExplorer: preparePageData,
                          );
                        }),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void preparePageData(bool comingFromCoupleProfile) async {
    await getAllCouples().then((coupleList) {
      couples.value = coupleList["couples"];
    });

    var apiResponse = await getTrendingCouples();
    if (apiResponse.isNotEmpty) {
      trendingCouplesList.value = apiResponse["trending_couples"];
    }
  }

  void updateCoupleAdmiredState(bool newState) {}
}
