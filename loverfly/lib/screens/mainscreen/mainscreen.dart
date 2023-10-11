import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/authenticationapi.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/screens/mainscreen/couplepost/viewcouplepost.dart';
import 'package:loverfly/utils/pageutils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../coupleexplorerscreen/viewcoupleexplorer.dart';
import '../myprofilescreen/myprofilescreen.dart';
import 'api/mainscreenapi.dart';

class MainScreen extends StatelessWidget {
  MainScreen({key, required this.desiredPageIndex}) : super(key: key);

  final Rx<List> posts = Rx<List>([]);
  final Rx<bool> postsFound = Rx<bool>(false);
  final Rx<bool> pageLoading = Rx<bool>(true);
  final RxBool pageLoaded = RxBool(false);
  final int desiredPageIndex;
  final RxInt initialPageIndex = RxInt(0);
  final RxMap pageData = RxMap({
    "pagination_link": null,
    "couple": {},
  });

  // TODO: find a way to globally have access to the shared preferences instance so i don't call it everywhere:

  void preparePageData(comingFromCouplePage, context) async {
    if (!pageLoaded.value || comingFromCouplePage == true) {
      try {
        var instance = await SharedPreferences.getInstance();
        await AuthenticationAPI()
            .getUserProfileAndCoupleData(instance.get("token"), context)
            .then((Map response) async {
          if (!response.keys.contains("error")) {
            var userProfile = response["user_profile"];
            var couple = response["couple"];

            // update local storage with new data:
            instance.setString("user_profile", jsonEncode(userProfile));
            instance.setString("user_couple", jsonEncode(couple));

            // update pagedata with new data:
            pageData["user_profile"] = userProfile;
            pageData["couple"] = couple;
          }
          preparePostsForFeed();
        });
      } catch (e) {
        SnackBars().displaySnackBar(
            "Something went wrong while loading this page.",
            () => null,
            context);
      }
    }
  }

  void preparePostsForFeed() async {
    pageData["pagination_link"] = null;
    await getPostsForFeed(null).then((Map response) {
      if (response["posts"] != null) {
        posts.value = response["posts"];
        response["pagination_link"] != null
            ? pageData["pagination_link"] = response["pagination_link"]
            : pageData["pagination_link"] = "";
      } else {
        posts.value = [];
      }
      posts.value.isEmpty ? postsFound.value = false : postsFound.value = true;
      pageLoaded.value = true;
    }).whenComplete(() => pageLoading.value = false);
  }

  void addMorePosts(context) async {
    var paginationLink = pageData["pagination_link"];
    if (paginationLink != "") {
      await getPostsForFeed(paginationLink).then((Map response) {
        if (!response.containsKey("error")) {
          posts.update((val) {
            val!.addAll(response["posts"]);
          });
        } else {
          SnackBars().displaySnackBar(
              "There was an error adding more posts", () => null, context);
        }
        response["pagination_link"] != null
            ? pageData["pagination_link"] = response["pagination_link"]
            : pageData["pagination_link"] = null;
      });
    }
  }

  void logOut(context) async {
    try {
      SharedPreferences cache = await SharedPreferences.getInstance();
      cache.clear();
      Get.offAll(() => SignInScreen());
    } catch (e) {
      SnackBars().displaySnackBar(
          "There was an error logging out.", () => null, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    preparePageData(false, context);

    return Scaffold(
        drawer: SizedBox(
          width: 250.0,

          // drawer menu
          child: Drawer(
            child: ListView(
              children: [
                const SizedBox(
                  height: 100.0,
                ),

                // couple explorer button
                SizedBox(
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
                  child: CustomButton(
                    buttonlabel: "Log Out",
                    textfontsize: 12.0,
                    onpressedfunction: () {
                      logOut(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        appBar: customAppBar(context, ''),

        // main body:
        body: Obx(
          () => DefaultTabController(
              initialIndex: desiredPageIndex,
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
                                    const Center(
                                        child: SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            backgroundColor: Colors.white,
                                            color: Colors.purpleAccent,
                                          ),
                                        ),
                                      )
                                    : postsFound.value == false
                                        ?

                                        // couple explorer navigator page:
                                        Column(
                                            children: [
                                              const SizedBox(height: 100.0),
                                              // welcome to loverfly text
                                              const Center(
                                                  child: Text(
                                                'Welcome to LoverFly!',
                                                style: TextStyle(
                                                    color: Colors.purple),
                                              )),
                                              const SizedBox(height: 50.0),
                                              // descriptive text
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0, right: 30.0),
                                                child: const Text(
                                                  "It looks like you're not following any couples. Start by exploring some below",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w300),
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
                                          )
                                        :

                                        // couple post page view:
                                        ListView.builder(
                                            itemCount: posts.value.length,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              // trigger pagination when at the end of the list:
                                              if (index + 1 ==
                                                  posts.value.length) {
                                                if (pageData[
                                                            "pagination_link"] !=
                                                        "" ||
                                                    pageData[
                                                            "pagination_link"] !=
                                                        null) {
                                                  addMorePosts(context);
                                                }
                                              }

                                              // couple post
                                              return CouplePost(
                                                postdata: posts.value[index],
                                                rebuildPageFunction:
                                                    preparePageData,
                                              );
                                            })),

                            // user profile page:
                            MyProfile(
                              reloadPosts: preparePostsForFeed,
                            ),
                          ],
                        ))),
              ])),
        ));
  }
}
