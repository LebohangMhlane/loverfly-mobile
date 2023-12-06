import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/api/authentication/authenticationapi.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/screens/mainscreen/couplepost/viewcouplepost.dart';
import 'package:loverfly/screens/mainscreen/mainscreenprovider.dart';
import 'package:loverfly/utils/pageutils.dart';
import 'package:provider/provider.dart';
import '../coupleexplorerscreen/coupleexplorerpage.dart';
import '../myprofilescreen/myprofilescreen.dart';
import 'api/mainscreenapi.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({key, required this.desiredPageIndex}) : super(key: key);

  final int desiredPageIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GetStorage cache = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MainScreenProvider mainPageProviderRead;
  late MainScreenProvider mainPageProviderWatch;

  void preparePageData(comingFromCouplePage, context) async {
    try {
      var auth = AuthenticationAPI();
      var response =
          await auth.getUserProfileAndCoupleData(cache.read("token"), context);
      if (response.keys.contains("error")) {
        throw Exception(response["error"]);
      } else {
        var userProfile = response["user_profile"];
        var couple = response["couple"];
        cache.write("user_profile", jsonEncode(userProfile));
        cache.write("user_couple", jsonEncode(couple));
      }
      preparePostsForFeed();
    } catch (e) {
      SnackBars().displaySnackBar(
          "Something went wrong while loading this page.", () => null, context);
    }
  }

  void updateCommentCountMain(bool increment, int postIndex) {
    // increment
    //     ? posts.value[postIndex]["comments_count"] =
    //         posts.value[postIndex]["comments_count"] + 1
    //     : posts.value[postIndex]["comments_count"] =
    //         posts.value[postIndex]["comments_count"] - 1;
  }

  void preparePostsForFeed() async {
    try {
      var response = await getPostsForFeed(null);
      mainPageProviderRead.updateValue("paginationLink", "");
      if (response["posts"] != null) {
        mainPageProviderRead.updateValue("posts", response["posts"]);
        var link = response["pagination_link"];
        link != null
            ? mainPageProviderRead.updateValue("paginationLink", link)
            : mainPageProviderRead.updateValue("paginationLink", "");
      } else {
        mainPageProviderRead.updateValue("posts", []);
      }
      mainPageProviderWatch.mainScreenData["posts"].isEmpty
          ? mainPageProviderRead.updateValue("postsFound", false)
          : mainPageProviderRead.updateValue("postsFound", true);
      mainPageProviderRead.updateValue("loadingPage", false);
    } catch (e) {
      SnackBars().displaySnackBar(
          "Something went wrong loading this page", () => null, context);
    }
  }

  void addMorePosts(context) async {
    // var paginationLink = pageData["pagination_link"];
    // if (paginationLink != "") {
    //   await getPostsForFeed(paginationLink).then((Map response) {
    //     if (!response.containsKey("error")) {
    //       posts.update((val) {
    //         if (response["posts"].length == 0) {
    //           pageData["pagination_link"] = "";
    //         } else {
    //           val!.addAll(response["posts"]);
    //         }
    //       });
    //     } else {
    //       SnackBars().displaySnackBar(
    //           "There was an error adding more posts", () => null, context);
    //     }
    //     response["pagination_link"] != null
    //         ? pageData["pagination_link"] = response["pagination_link"]
    //         : pageData["pagination_link"] = null;
    //   });
    // }
  }

  void logOut(context) async {
    try {
      cache.erase();
      Navigator.of(context).pushReplacementNamed("/signInScreen");
    } catch (e) {
      SnackBars().displaySnackBar(
          "There was an error logging out.", () => null, context);
    }
  }

  @override
  void initState() {
    preparePageData(false, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainPageProviderRead = context.read<MainScreenProvider>();
    mainPageProviderWatch = context.watch<MainScreenProvider>();
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await showDialog(
          context: context,
          builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300.0,
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 80.0),
                        child: Text(
                          "Are you sure you want to exit?",
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              width: 120.0,
                              borderradius: 10.0,
                              buttoncolor: Colors.purple,
                              buttonlabel: "Yes",
                              onpressedfunction: () =>
                                  Navigator.of(context).pop(true),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            CustomButton(
                              width: 120.0,
                              borderradius: 10.0,
                              buttoncolor: Colors.purple,
                              buttonlabel: "No",
                              onpressedfunction: () =>
                                  Navigator.of(context).pop(false),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        return exitApp;
      },
      child: Scaffold(
          key: _scaffoldKey,
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
                        Navigator.of(context).pushNamed("/coupleExplorer");
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
          body: Stack(children: [
            // main page:
            DefaultTabController(
                initialIndex: widget.desiredPageIndex,
                length: 2,
                child:
                    Column(verticalDirection: VerticalDirection.up, children: [
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
                                  child: context
                                          .watch<MainScreenProvider>()
                                          .mainScreenData["loadingPage"]
                                      ?
                                      // loading indicator:
                                      const Center(
                                          child: SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.0,
                                              backgroundColor: Colors.white,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        )
                                      : mainPageProviderWatch.mainScreenData[
                                                  "postsFound"] ==
                                              false
                                          ? Column(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0,
                                                          right: 30.0),
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
                                              itemCount: mainPageProviderWatch
                                                  .mainScreenData["posts"]
                                                  .length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                // trigger pagination when at the end of the list:
                                                if (index + 1 ==
                                                    mainPageProviderWatch
                                                        .mainScreenData["posts"]
                                                        .length) {
                                                  if (mainPageProviderWatch
                                                              .mainScreenData[
                                                          "paginationLink"] !=
                                                      "") {
                                                    addMorePosts(context);
                                                  }
                                                }

                                                // couple post:
                                                return CouplePost(
                                                  postIndex: index,
                                                  updateCommentCountMain:
                                                      updateCommentCountMain,
                                                  postdata:
                                                      mainPageProviderWatch
                                                              .mainScreenData[
                                                          "posts"][index],
                                                  rebuildPageFunction:
                                                      preparePageData,
                                                );
                                              })),

                              // user profile page:
                              MyProfile(
                                scaffoldKey: _scaffoldKey,
                                reloadPosts: preparePostsForFeed,
                              ),
                            ],
                          ))),
                ])),
          ])),
    );
  }
}
