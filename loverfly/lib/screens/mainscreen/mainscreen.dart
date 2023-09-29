// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, prefer_typing_uninitialized_variables, avoid_print, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/authenticationapi.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/screens/mainscreen/couplepost/viewcouplepost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../coupleexplorerscreen/viewcoupleexplorer.dart';
import '../myprofilescreen/myprofilescreen.dart';
import 'api/mainscreenapi.dart';

class MainScreen extends StatelessWidget {
  MainScreen({key}) : super(key: key);

  final Rx<List> posts = Rx<List>([]);
  final Rx<bool> postsFound = Rx<bool>(false);
  final Rx<bool> pageLoading = Rx<bool>(true);
  final RxBool pageLoaded = RxBool(false);
  final RxMap pageData = RxMap({
    "pagination_link": null,
    "couple": {},
  });

  @override
  Widget build(BuildContext context) {
    preparePageData(false);

    return Scaffold(
        drawer: Container(
          width: 250.0,

          // drawer menu
          child: Drawer(
            child: ListView(
              children: [
                const SizedBox(
                  height: 100.0,
                ),

                // couple explorer button
                Container(
                  height: 60.0,
                  child: CustomButton(
                    buttonlabel: 'Couple Explorer',
                    textfontsize: 12.0,
                    buttoncolor: Colors.purple,
                    onpressedfunction: () {
                      Get.to(() => CoupleExplorerScreen());
                    },
                  ),
                ),

                // button 2
                Container(
                  height: 60.0,
                  color: Colors.blue,
                ),

                //  button 3
                Container(
                  height: 60.0,
                  color: Colors.yellow,
                )
              ],
            ),
          ),
        ),
        appBar: customAppBar(context, ''),

        // main body:
        body: Obx(
          () => DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Column(verticalDirection: VerticalDirection.up, children: [
                // tab bar switch buttons:
                Container(
                  height: 40.0,
                  color: Colors.black,
                  child: const TabBar(
                    indicatorColor: Colors.purple,
                    tabs: [
                      // home feed button
                      Tab(text: 'Couples'),
                      // my profile button
                      Tab(
                        child: Icon(Icons.person),
                      ),
                    ],
                  ),
                ),

                // tab screens:
                Expanded(
                    child: Container(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: TabBarView(
                          children: [
                            // couple posts page:
                            Container(
                                child: pageLoading.value
                                    ?
                                    // loading indicator:
                                    Container(
                                        child: Center(
                                          child: Container(
                                            width: 20.0,
                                            height: 20.0,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              backgroundColor: Colors.white,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                      )
                                    : postsFound.value == false
                                        ?

                                        // couple explorer navigator page:
                                        Container(
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 100.0),
                                                // welcome to loverfly text
                                                Container(
                                                  child: const Center(
                                                      child: Text(
                                                    'Welcome to LoverFly!',
                                                    style: TextStyle(
                                                        color: Colors.purple),
                                                  )),
                                                ),
                                                const SizedBox(height: 50.0),
                                                // descriptive text
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0,
                                                          right: 30.0),
                                                  child: const Text(
                                                    "It looks like you're not following any couples. Start by exploring some below",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.purple,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 50.0),
                                                // couple explorer navigation button
                                                Container(
                                                  width: 170.0,
                                                  height: 60.0,
                                                  color: Colors.white,
                                                  child: CustomButton(
                                                    buttonlabel:
                                                        'Couple Explorer',
                                                    borderradius: 20.0,
                                                    buttoncolor: Colors.purple,
                                                    onpressedfunction: () {
                                                      Get.to(() =>
                                                          CoupleExplorerScreen());
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        :

                                        // couple post page view:
                                        ListView.builder(
                                            itemCount: posts.value.length,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              print(index + 1);
                                              // trigger pagination when at the end of the list:
                                              if (index + 1 ==
                                                  posts.value.length) {
                                                if (pageData.value[
                                                            "pagination_link"] !=
                                                        "" ||
                                                    pageData.value[
                                                            "pagination_link"] !=
                                                        null) {
                                                  addMorePosts();
                                                }
                                              }

                                              // couple post
                                              return CouplePost(
                                                postdata: posts.value[index],
                                                resetPageFunction:
                                                    preparePageData,
                                              );
                                            })),

                            // user profile page:
                            Container(
                                // user profile:
                                child: MyProfile(
                              reloadPosts: preparePostsForFeed,
                              couple: pageData["couple"],
                              userProfile: pageData.value["user_profile"],
                            )),
                          ],
                        ))),
              ])),
        ));
  }

  void preparePageData(comingFromCouplePage) async {
    if (!pageLoaded.value || comingFromCouplePage == true) {
      // pageLoading.value ? pageLoading.value = true : pageLoading.value;
      try {
        var instance = await SharedPreferences.getInstance();
        await AuthenticationAPI()
            .getUserProfileAndCoupleData(instance.get("token"))
            .then((responseMap) async {
          if (!responseMap.keys.contains("error")) {
            var userProfile = responseMap["user_profile"];
            var couple = responseMap["couple"];

            // update local storage with new data:
            instance.setString("user_profile", jsonEncode(userProfile));
            instance.setString("user_couple", jsonEncode(couple));

            // update pagedata with new data:
            pageData.value["user_profile"] = userProfile;
            pageData.value["couple"] = couple;
          }
          preparePostsForFeed();
        });
      } catch (e) {
        print("Something went wrong loading this page");
      }
    }
  }

  void preparePostsForFeed() async {
    pageData.value["pagination_link"] = null;
    await getPostsForFeed(null).then((responseMap) {
      if (responseMap["posts"] != null) {
        posts.value = responseMap["posts"];
        pageData.value["pagination_link"] = responseMap["pagination_link"];
      } else {
        posts.value = [];
      }
      posts.value.isEmpty ? postsFound.value = false : postsFound.value = true;
      pageLoaded.value = true;
    }).whenComplete(() => pageLoading.value = false);
  }

  void addMorePosts() async {
    var paginationLink = pageData.value["pagination_link"];
    if (paginationLink != null) {
      await getPostsForFeed(paginationLink).then((responseMap) {
        posts.update((val) {
          val!.addAll(responseMap["posts"]);
        });
        pageData.value["pagination_link"] = responseMap["pagination_link"];
      });
    }
  }
}
