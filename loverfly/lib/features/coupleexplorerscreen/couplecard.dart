// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/features/coupleexplorerscreen/coupleexplorerprovider/coupleexplorerpageprovider.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/features/view_couple_screen/viewcouple.dart';
import 'package:provider/provider.dart';
import '../../utils/pageutils.dart';

class CoupleCard extends StatelessWidget {
  const CoupleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoupleCardProvider>(
      builder: (context, coupleCardProvider, child) => Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 10.0),

            // section 1 - usernames:
            Container(
              child: Row(
                children: [
                  // username 1
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        coupleCardProvider.partnerOneUsername,
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
                      coupleCardProvider.partnerTwoUsername,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // section 2 - profile pictures:
            GestureDetector(
              onTap: () {
                Get.to(() => ViewCouple(
                      couple: Couple.createFromJson({}),
                    ));
              },
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
                                backgroundImage: coupleCardProvider
                                            .partnerOneProfilePic ==
                                        ""
                                    ? const NetworkImage(
                                        "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png")
                                    : NetworkImage(coupleCardProvider
                                        .partnerOneProfilePic),
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
                                'Admirers',
                                style: TextStyle(fontSize: 11.0),
                              ),
                            ),

                            const SizedBox(
                              height: 4.0,
                            ),

                            // heart icon
                            Container(
                              child: SvgPicture.asset(
                                'assets/svg/heart.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.blue, BlendMode.srcIn),
                                width: 20.0,
                              ),
                            ),

                            const SizedBox(
                              height: 0.0,
                            ),

                            // admirer count:
                            Center(
                                child: Container(
                              child: Text(
                                  coupleCardProvider.admirersCount.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )),
                            ))
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
                                backgroundImage: coupleCardProvider
                                            .partnerTwoProfilePic ==
                                        ""
                                    ? const NetworkImage(
                                        "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png")
                                    : NetworkImage(coupleCardProvider
                                        .partnerTwoProfilePic),
                                radius: 25.0,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),

            // section 3 - functional buttons:
            SizedBox(
              height: 60.0,
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    child: Center(
                      child: CustomButton(
                          width: MediaQuery.of(context).size.width,
                          buttoncolor: Colors.purple,
                          buttonlabel: 'Admire',
                          icon: Icon(Icons.star,
                              color: coupleCardProvider.isAdmired
                                  ? const Color.fromARGB(164, 255, 235, 59)
                                  : const Color.fromARGB(163, 231, 231, 228)),
                          onpressedfunction: () async {
                            if (coupleCardProvider.admiring) {
                              SnackBars().displaySnackBar(
                                  "Please wait for the process to finish",
                                  () {},
                                  context);
                            } else {
                              bool coupleAdmired = await coupleCardProvider
                                  .admireOrUnAdmireCouple();
                              !coupleAdmired
                                  ? SnackBars().displaySnackBar(
                                      "An error has occured", () {}, context)
                                  : null;
                            }
                          }),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
