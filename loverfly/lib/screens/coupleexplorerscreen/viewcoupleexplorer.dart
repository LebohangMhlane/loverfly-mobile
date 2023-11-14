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
  final RxBool pageLoading = RxBool(true);

  void preparePageData(bool comingFromCoupleProfile) async {
    await getAllCouples().then((coupleList) {
      couples.value = coupleList["couples"];
    });

    var apiResponse = await getTrendingCouples();
    if (apiResponse.isNotEmpty && !apiResponse.containsKey("error_info")) {
      trendingCouplesList.value = apiResponse["trending_couples"];
    }

    pageLoading.value = false;
  }

  void updateCoupleAdmiredState(bool newState) {}

  @override
  Widget build(BuildContext context) {
    preparePageData(true);

    return WillPopScope(
      onWillPop: () {
        Get.offAll(() => MainScreen(
              desiredPageIndex: 0,
            ));
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context, 'Couple Explorer'),
        body: Obx(() => pageLoading.isFalse
            ? Column(
                children: [
                  // trending couples scroll list:
                  TrendingCouples(
                    trendingCouplesList: trendingCouplesList.value,
                    rebuildCoupleExplorer: preparePageData,
                  ),

                  // couples:
                  couples.value.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Text(
                              "There are currently no couples to admire.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0,
                                  color: Colors.purple),
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 5,
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
                ],
              )
            : const Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    color: Colors.purple,
                  ),
                ),
              )),
      ),
    );
  }
}
