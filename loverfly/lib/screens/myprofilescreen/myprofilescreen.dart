// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/screens/coupleexplorerscreen/viewcoupleexplorer.dart';
import 'package:loverfly/screens/editprofilepicturescreen/editprofilepicturescreen.dart';
import 'package:loverfly/screens/listviewscreens/listviewscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/pageutils.dart';
import '../couplelink/generatecode.dart';
import '../couplelink/inputcode.dart';
import '../couplescreen/api/couplescreenapi.dart';
import '../createapostscreen/createapost.dart';
import '../largerpreviewscreen/largerpreviewscreen.dart';

class MyProfile extends StatelessWidget {
  final Function reloadPosts;
  final RxMap userProfile =
      RxMap({"is_straight": true, "username": "New User"});
  final RxMap couple = RxMap({});
  final RxBool pageReady = RxBool(false);

  MyProfile({
    Key? key,
    required this.reloadPosts,
  });

  final pageData = Rx<Map>({
    "has_notifications": false,
    "has_messages": false,
    "posts": [],
    "show_relationship_stage_options": false,
  });

  void preparePageData() async {
    try {
      pageReady.value = false;
      // get the couple from cache:
      SharedPreferences cache = await SharedPreferences.getInstance();
      cache.containsKey("user_couple")
          ? couple.value = jsonDecode(cache.getString("user_couple")!)
          : couple.value = {};

      cache.containsKey("user_profile")
          ? userProfile.value = jsonDecode(cache.getString("user_profile")!)
          : userProfile.value = {};
      // get my couples posts:
      if (couple.isNotEmpty) {
        await getCouplePosts(couple["id"]).then((listOfPosts) {
          pageData.update((map) {
            map!["posts"] = listOfPosts["couple_posts"];
            listOfPosts["couple_posts"].length == 0
                ? couple["has_posts"] = false
                : couple["has_posts"] = true;
          });
        });
      }
      pageReady.value = true;
    } catch (e) {
      print("something went wrong while loading this page");
    }
  }

  @override
  Widget build(BuildContext context) {
    preparePageData();
    return Obx(
      () => Scaffold(
          body: pageReady.value
              ? SingleChildScrollView(
                  child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                children: [
                                  // sexual orientation icon:
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 5.0),
                                            child: Image.asset(
                                              'assets/placeholders/logo.jpeg',
                                              width: 30.0,
                                            ),
                                          ),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 5.0),
                                              child: Text(
                                                  userProfile['is_straight']
                                                      ? 'Straight'
                                                      : 'LGBTQ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300))),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // profile picture:
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Stack(children: [
                                        Container(
                                            width: 95.0,
                                            height: 95.0,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100.0)),
                                                color: Colors.purpleAccent),
                                            padding: const EdgeInsets.all(1.0),
                                            child: CircleAvatar(
                                                radius: 40.0,
                                                backgroundImage: userProfile[
                                                                "profile_picture"]
                                                            ["image"] !=
                                                        null
                                                    ? NetworkImage(userProfile[
                                                            'profile_picture']
                                                        ["image"])
                                                    : const NetworkImage(
                                                        "https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg"))),
                                        Positioned(
                                          bottom: 7.0,
                                          left: 70.0,
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(() =>
                                                  const EditProfilePictureScreen());
                                            },
                                            child: Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.purple,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),

                                  // relationship status:
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: couple.isEmpty
                                          ? const Text(
                                              'Single',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Text(
                                              'Taken',
                                              style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ROW 1

                            // ROW 2
                            // USERNAME
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              child: Text(
                                userProfile['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            // ROW 2

                            // ROW 3
                            Container(
                              height: 50.0,
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  // COUPLE EXPLORER BUTTON
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {
                                        Get.to(() => CoupleExplorerScreen());
                                      },
                                      child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                Icon(
                                                  Icons.search_rounded,
                                                  color: Colors.deepPurple,
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),

                                  // RELATIONSHIP ADVICE MESSAGES
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                const Icon(
                                                  Icons.mail,
                                                  color: Colors.deepPurple,
                                                ),
                                                pageData.value["has_messages"]
                                                    ? SvgPicture.asset(
                                                        'assets/svg/heart.svg',
                                                        width: 10.0,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.red,
                                                                BlendMode
                                                                    .srcIn),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/svg/heart.svg',
                                                        width: 10.0,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.grey,
                                                                BlendMode
                                                                    .srcIn),
                                                      )
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),

                                  // NOTIFICATIONS BUTTON:
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                const Icon(
                                                  Icons.notifications_active,
                                                  color: Colors.deepPurple,
                                                ),
                                                pageData.value["has_messages"]
                                                    ? SvgPicture.asset(
                                                        'assets/svg/heart.svg',
                                                        width: 10.0,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.red,
                                                                BlendMode
                                                                    .srcIn),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/svg/heart.svg',
                                                        width: 10.0,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Colors.grey,
                                                                BlendMode
                                                                    .srcIn),
                                                      )
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ROW 3

                            const Divider(
                              thickness: 1.0,
                              indent: 60.0,
                              endIndent: 60.0,
                            ),

                            // LINK ACCOUNT BUTTON
                            couple.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 20.0, bottom: 20.0),
                                          padding: const EdgeInsets.only(
                                              left: 30.0, right: 30.0),
                                          child: const Text(
                                            'You appear to be Single. Not true? Link your account with your partners account to show the world who your heart belongs to and start sharing your sweetest moments together with the world!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12.0),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(() => GenerateCodeScreen());
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 2.0,
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100.0)))),
                                          child: const Text(
                                            'Generate a Link Code',
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        const Text(
                                          "or",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(() => InputCodeScreen());
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 2.0,
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100.0)))),
                                          child: const Text(
                                            'Link accounts',
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                :

                                // ROW 4
                                // IN A RELATIONSHIP TITLE
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 15.0),
                                    child: const Text(
                                      'In a relationship with:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                            // ROW 4

                            // LINK ACCOUNT DESCRIPTION
                            couple.isEmpty
                                ? Container()
                                :

                                // ROW 5
                                // RELATIONSHIP PARTNER
                                Container(
                                    child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                        Row(
                                          children: [
                                            // COL 1
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    // PARTNER PROFILE PICTURE
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                            width: 70.0,
                                                            height: 70.0,
                                                            decoration: const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            100.0)),
                                                                color: Colors
                                                                    .purple),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: CircleAvatar(
                                                              radius: 50.0,
                                                              backgroundImage: userProfile["my_partner"]
                                                                              [
                                                                              'profile_picture']
                                                                          [
                                                                          "image"] !=
                                                                      null
                                                                  ? NetworkImage(
                                                                      userProfile["my_partner"]
                                                                              [
                                                                              'profile_picture']
                                                                          [
                                                                          "image"])
                                                                  : const NetworkImage(
                                                                      "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png"),
                                                            )),
                                                      ),
                                                    ),

                                                    // PARTNER USERNAME
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                          child: Text(
                                                              userProfile[
                                                                      "my_partner"]
                                                                  ['username'],
                                                              style: const TextStyle(
                                                                  letterSpacing:
                                                                      2.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300))),
                                                    ),

                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),

                                                    // RELATIONSHIP STAGE BUTTON
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 20.0,
                                                        right: 20.0,
                                                      ),
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100.0)),
                                                      ),
                                                      height: 40.0,
                                                      child: TextButton(
                                                        style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 2.0,
                                                            shadowColor:
                                                                Colors.black,
                                                            foregroundColor:
                                                                Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.0),
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            100.0)))),
                                                        onPressed: () {
                                                          pageData.value[
                                                                  "show_relationship_stage_options"] =
                                                              pageData.value[
                                                                          "show_relationship_stage_options"] ==
                                                                      false
                                                                  ? true
                                                                  : false;
                                                          pageData
                                                              .update((val) {});
                                                        },
                                                        child: Container(
                                                          child: Center(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  child: Text(
                                                                      couple[
                                                                          "relationship_status"],
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ))),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5.0),
                                                                child: couple[
                                                                            "relationship_status"] ==
                                                                        'Dating'
                                                                    ? SvgPicture
                                                                        .asset(
                                                                        'assets/svg/twohearts.svg',
                                                                        width:
                                                                            15.0,
                                                                        colorFilter: const ColorFilter
                                                                            .mode(
                                                                            Colors.redAccent,
                                                                            BlendMode.srcIn),
                                                                      )
                                                                    : couple["relationship_status"] ==
                                                                            'Engaged'
                                                                        ? SvgPicture
                                                                            .asset(
                                                                            'assets/svg/rings1.svg',
                                                                            width:
                                                                                15.0,
                                                                            colorFilter:
                                                                                const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                                                                          )
                                                                        : couple["relationship_status"] ==
                                                                                'Married'
                                                                            ? SvgPicture.asset(
                                                                                'assets/svg/rings2.svg',
                                                                                width: 15.0,
                                                                                colorFilter: const ColorFilter.mode(Colors.pink, BlendMode.srcIn),
                                                                              )
                                                                            : Container(),
                                                              )
                                                            ],
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // COL 2
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    // ADMIRER COUNTER
                                                    Container(
                                                        width: 100.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 21.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          4.0,
                                                                      top: 1.0),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: SvgPicture.asset(
                                                                      'assets/svg/heart.svg',
                                                                      colorFilter: const ColorFilter
                                                                          .mode(
                                                                          Colors
                                                                              .blue,
                                                                          BlendMode
                                                                              .srcIn),
                                                                      width:
                                                                          15.0)),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                child: Text(
                                                                    couple["admirers"]
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w300)),
                                                              ),
                                                            )
                                                          ],
                                                        )),

                                                    const SizedBox(
                                                        height: 11.0),

                                                    // RELATIONSHIP DURATION DETAILS
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: const Text(
                                                          'Together Since',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        couple[
                                                            "started_dating"],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: const Text(
                                                          'Next Anniversary',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        couple[
                                                            "next_anniversary"],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // RELATIONSHIP STAGE OPTIONS MENU
                                        pageData.value[
                                                "show_relationship_stage_options"]
                                            ? Positioned(
                                                bottom: 2.0,
                                                left: 195.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20.0)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0,
                                                        blurRadius: 1,
                                                        offset: const Offset(0,
                                                            2), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  width: 200.0,
                                                  height: 150.0,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  pageData.value[
                                                                          "show_relationship_stage_options"] =
                                                                      pageData.value["show_relationship_stage_options"] ==
                                                                              false
                                                                          ? true
                                                                          : false;
                                                                  pageData.value =
                                                                      pageData
                                                                          .value;
                                                                },
                                                                child: Text(
                                                                    'Dating',
                                                                    style: TextStyle(
                                                                        color: couple["relationship_status"] ==
                                                                                'Dating'
                                                                            ? Colors.blue
                                                                            : Colors.purple)),
                                                              ))),
                                                      Expanded(
                                                          child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: TextButton(
                                                                onPressed:
                                                                    () {},
                                                                child: Text(
                                                                    'Engaged',
                                                                    style: TextStyle(
                                                                        color: couple["relationship_status"] ==
                                                                                'Engaged'
                                                                            ? Colors.blue
                                                                            : Colors.purple)),
                                                              ))),
                                                      Expanded(
                                                          child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: TextButton(
                                                                onPressed:
                                                                    () {},
                                                                child: Text(
                                                                    'Married',
                                                                    style: TextStyle(
                                                                        color: couple["relationship_status"] ==
                                                                                'Married'
                                                                            ? Colors.blue
                                                                            : Colors.purple)),
                                                              ))),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ])),
                            // ROW 5

                            const SizedBox(
                              height: 10.0,
                            ),

                            const Divider(
                              thickness: 1.0,
                              indent: 60.0,
                              endIndent: 60.0,
                            ),

                            // ROW 6
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 15.0),
                              child: Row(
                                children: [
                                  // Admirers:
                                  couple.isEmpty
                                      ? Container()
                                      : Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              Get.to(() => ListViewScreen(
                                                  listType: "Admirers"));
                                            },
                                            child: Container(
                                                child: Column(children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0, bottom: 6.0),
                                                child: const Text(
                                                  'Admirers',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: SvgPicture.asset(
                                                  'assets/svg/heart.svg',
                                                  width: 20.0,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Colors.blue,
                                                          BlendMode.srcIn),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Text(couple["admirers"]
                                                    .toString()),
                                              )
                                            ])),
                                          ),
                                        ),

                                  // Admired Couples:
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        print('Admired List');
                                      },
                                      child: Container(
                                          child: Column(children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 6.0, bottom: 6.0),
                                          child: const Text(
                                            'Admired Couples',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6.0),
                                          child: SvgPicture.asset(
                                            'assets/svg/heart.svg',
                                            width: 20.0,
                                            colorFilter: const ColorFilter.mode(
                                                Colors.red, BlendMode.srcIn),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                              userProfile[
                                                      "number_of_admired_couples"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.red)),
                                        ),
                                      ])),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // TITLE
                            Container(
                                color: Colors.deepPurple,
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 19.0),
                                child: const Center(
                                    child: Text('Memories',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300)))),

                            const SizedBox(height: 9.0),

                            // CREATE A MEMORY BUTTON
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 0.0,
                                        top: 5.0,
                                        bottom: 15.0),
                                    margin: const EdgeInsets.only(
                                        left: 100.0, right: 100.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: TextButton(
                                                onPressed: () {
                                                  if (couple.isNotEmpty) {
                                                    Get.off(() =>
                                                        CreateAPostScreen(
                                                            resetPageFunction:
                                                                reloadPosts));
                                                  } else {
                                                    SnackBars().displaySnackBar(
                                                        "You need to be in a relationship to create memories",
                                                        () {},
                                                        context);
                                                  }
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      children: [
                                                        // icons
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10.0,
                                                                  bottom: 10.0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerRight,
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .camera_alt_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .image,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.white,
                                                                        )),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                style: TextButton.styleFrom(
                                                    elevation: 2.0,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    foregroundColor: Colors
                                                        .white
                                                        .withOpacity(.1),
                                                    backgroundColor:
                                                        Colors.deepPurpleAccent,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100.0))))),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 0.0),

                            // ROW 6
                            couple["has_posts"] == false || couple.isEmpty
                                ? Container()
                                :
                                // POST GALLERY
                                Container(
                                    child: Column(
                                      children: [
                                        // IMAGE LIST
                                        Container(
                                            height: 450.0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              height: 30.0,
                                              child: GridView.builder(
                                                itemCount: pageData
                                                    .value["posts"].length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2),
                                                itemBuilder: (context, index) {
                                                  return TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0)),
                                                    onPressed: () {
                                                      Get.to(
                                                          () =>
                                                              LargerPreviewScreen(
                                                                imageurl: pageData
                                                                            .value[
                                                                        "posts"][index]
                                                                    [
                                                                    "post_image"],
                                                                myImage: true,
                                                                postId: pageData
                                                                            .value[
                                                                        "posts"]
                                                                    [
                                                                    index]["id"],
                                                                resetPage:
                                                                    reloadPosts,
                                                              ),
                                                          opaque: false);
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .all(2.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  pageData.value[
                                                                              "posts"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "post_image"]),
                                                              fit:
                                                                  BoxFit.cover),
                                                        )),
                                                  );
                                                },
                                              ),
                                            )),

                                        const SizedBox(height: 10.0),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
              : Center(
                  child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.0,
                    color: Colors.purple,
                  ),
                ))),
    );
  }
}
