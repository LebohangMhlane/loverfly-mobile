// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/custombutton.dart';
import '../../userinteractions/favourite/favouriteapi.dart';
import '../../utils/pageutils.dart';

class CoupleCard extends StatelessWidget {
  CoupleCard({
    Key? key,
    required this.coupleData,
    required this.rebuildCoupleExplorer,
  }) : super(key: key);

  final Map coupleData;
  final coupleFanCount = Rx<int>(0);
  final Rx<Map> pageData = Rx({});
  final RxBool isFavourited = RxBool(false);
  final RxBool favouriting = RxBool(false);
  final Function rebuildCoupleExplorer;

  @override
  Widget build(BuildContext context) {
    preparepagedata();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20.0),

          // section 1 - usernames
          Container(
            child: Row(
              children: [
                // username 1
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      coupleData['couple']["partner_one"]["username"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),

                const Center(child: Text(" + ")),

                // username 2
                Expanded(
                  flex: 6,
                  child: Text(
                    coupleData['couple']["partner_two"]["username"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // section 2 - profile pictures
          GestureDetector(
            onTap: () => PageUtils()
                .navigateToCoupleScreen(coupleData, rebuildCoupleExplorer),
            child: SizedBox(
              height: 150.0,
              child: Row(
                children: [
                  // profile picture 1
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                color: Colors.purple),
                            padding: const EdgeInsets.all(3.0),
                            width: 100.0,
                            height: 100.0,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(coupleData["couple"]
                                  ['partner_one']["profile_picture"]),
                              radius: 25.0,
                            ),
                          ),
                        ),
                      )),

                  // follower stats
                  Expanded(
                      child: Container(
                          child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      color: Colors.white,
                      child: Column(
                        children: [
                          // followers title
                          Container(
                            child: const Text(
                              'Fans',
                              style: TextStyle(fontSize: 11.0),
                            ),
                          ),

                          const SizedBox(
                            height: 5.0,
                          ),

                          // heart icon
                          Container(
                            child: SvgPicture.asset(
                              'assets/svg/heart.svg',
                              color: Colors.blue,
                              width: 20.0,
                            ),
                          ),

                          const SizedBox(
                            height: 5.0,
                          ),

                          // follower count
                          Center(
                              child: Obx(() => Container(
                                    child: Text(
                                      coupleFanCount.value.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ))),

                  // profile picture 2
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                color: Colors.purple),
                            padding: const EdgeInsets.all(3.0),
                            width: 100.0,
                            height: 100.0,
                            child: CircleAvatar(
                              backgroundImage: coupleData["couple"]
                                          ['partner_two']["profile_picture"] !=
                                      null
                                  ? NetworkImage(coupleData["couple"]
                                      ['partner_two']["profile_picture"])
                                  : const NetworkImage(
                                      "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png"),
                              radius: 25.0,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

          // section 3 - functional buttons
          SizedBox(
            height: 60.0,
            child: Row(
              children: [
                // favourite couple button:
                Expanded(child: SizedBox(
                  child: Center(
                    child: Obx(() {
                      return CustomButton(
                          buttoncolor: Colors.purple,
                          buttonlabel: 'Favourite',
                          icon: Icon(Icons.star,
                              color: isFavourited.value
                                  ? const Color.fromARGB(164, 255, 235, 59)
                                  : const Color.fromARGB(163, 231, 231, 228)),
                          onpressedfunction: () async {
                            // lock the favourite button until the operation is done:
                            if (favouriting.value) {
                              print(
                                  'Currently working on favouriting. Please wait.');
                            } else {
                              favouriting.value = true;
                              favouriteCouple(context);
                            }
                          });
                    }),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void preparepagedata() {
    isFavourited.value = coupleData["isFavourited"];
    coupleFanCount.value = coupleData["couple"]["fans"];
  }

  void favouriteCouple(context) async {
    try {
      // make a request to the api:
      Map response =
          await favourite(coupleData["couple"]["id"], isFavourited.value);
      // if something goes wrong, notify the user:
      if (response.containsKey("error_info")) {
        SnackBars().displaySnackBar(
            "Something went wrong. We will fix it soon!", () => null, context);
      } else {
        // else, update the favourited values:
        isFavourited.value = response["favourited"];
        coupleData["isFavourited"] = response["favourited"];
        // update the fan count based on the returned value:
        if (isFavourited.value == false) {
          if (coupleFanCount.value != 0) {
            coupleFanCount.value--;
          }
        } else {
          coupleFanCount.value++;
        }
        favouriting.value = false;
      }
    } catch (e) {
      // if something goes wrong with the logic above, notify the user:
      SnackBars().displaySnackBar(
          "Something went wrong. We will fix it soon!", () => null, context);
    }
  }
}
