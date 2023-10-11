import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/pageutils.dart';

class TrendingCouples extends StatelessWidget {
  TrendingCouples(
      {Key? key,
      required this.trendingCouplesList,
      required this.rebuildCoupleExplorer})
      : super(key: key);

  final List trendingCouplesList;
  final RxList trendingCouples = RxList([]);
  final RxBool pageReady = RxBool(true);
  final Function rebuildCoupleExplorer;

  @override
  Widget build(BuildContext context) {
    preparePageData();

    return Obx(
      () => Expanded(
          child: pageReady.value
              ? Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // trending title
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 30.0),
                        child: const Text(
                          'Trending',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0,
                              color: Colors.purple),
                        ),
                      ),

                      // list of trending couples:
                      Expanded(
                        child: Container(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: Obx(
                              () => ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: trendingCouples.isNotEmpty
                                      ? trendingCouples.length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        PageUtils().navigateToCoupleScreen(
                                            trendingCouples[index],
                                            rebuildCoupleExplorer);
                                      },
                                      child: SizedBox(
                                          width: 110.0,
                                          child: Center(
                                            child: Stack(
                                              children: [
                                                // couple partner 1
                                                Positioned(
                                                  left: 60.0,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      100.0)),
                                                          color: Colors.purple),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child: CircleAvatar(
                                                        backgroundImage: trendingCouples[index]
                                                                            [
                                                                            "couple"]
                                                                        [
                                                                        "partner_one"]
                                                                    [
                                                                    "profile_picture"] ==
                                                                null
                                                            ? const NetworkImage(
                                                                'https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg')
                                                            : NetworkImage(trendingCouples[
                                                                            index]
                                                                        [
                                                                        "couple"]
                                                                    [
                                                                    'partner_one']
                                                                [
                                                                "profile_picture"]),
                                                        radius: 40.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // couple partner 2
                                                Positioned(
                                                  top: 15.0,
                                                  left: 17.0,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      100.0)),
                                                          color: Colors.purple),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child: CircleAvatar(
                                                        backgroundImage: trendingCouples[index]
                                                                            [
                                                                            "couple"]
                                                                        [
                                                                        'partner_two']
                                                                    [
                                                                    "profile_picture"] ==
                                                                null
                                                            ? const NetworkImage(
                                                                'https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg')
                                                            : NetworkImage(trendingCouples[
                                                                            index]
                                                                        [
                                                                        "couple"]
                                                                    [
                                                                    'partner_two']
                                                                [
                                                                "profile_picture"]),
                                                        radius: 25.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    );
                                  }),
                            )),
                      )
                    ],
                  ),
                )
              : const Center(
                  child: Text("Loading"),
                )),
    );
  }

  void preparePageData() async {
    trendingCouples.value = trendingCouplesList;
  }
}
