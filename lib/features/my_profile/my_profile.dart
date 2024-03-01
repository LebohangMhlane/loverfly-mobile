// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/features/larger_image_view/larger_image_view_screen.dart';
import 'package:loverfly/features/my_profile/my_profile_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/pageutils.dart';

class MyProfile extends StatefulWidget {

  final Function openDrawer;

  const MyProfile({
    required this.openDrawer,
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  @override
  void initState() {
    super.initState();
  }

  // TODO: change these to class based widgets:

  Widget renderLoadingIcon() {
    return Center(
        child: Container(
      width: 20.0,
      height: 20.0,
      child: const CircularProgressIndicator(
        strokeWidth: 1.0,
        color: Colors.purple,
      ),
    ));
  }

  Widget renderOrientation() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            // heart icon:
            Container(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Image.asset(
                'assets/placeholders/logo.jpeg',
                width: 30.0,
              ),
            ),
            // orientation text:
            Container(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: const Text("Straight",
                    style: TextStyle(fontWeight: FontWeight.w300))),
          ],
        ),
      ),
    );
  }

  Widget renderProfilePicture(userProfileProvider) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Stack(children: [
          // clickable profile picture:
          GestureDetector(
            onTap: () {},
            child: Container(
                width: 95.0,
                height: 95.0,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    color: Colors.purpleAccent),
                padding: const EdgeInsets.all(1.0),
                child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage:
                        NetworkImage(userProfileProvider.profilePicture))),
          ),
          // edit profile picture button:
          Positioned(
            bottom: 7.0,
            left: 70.0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(50.0)),
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
    );
  }

  Widget renderRelationShipStatus(userProfileProvider) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: userProfileProvider.couple.isEmpty
            ? const Text(
                'Single',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
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
    );
  }

  Widget renderCoupleExplorerButton() {
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.of(context).pushNamed("/coupleExplorerScreen");
        },
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget renderMessagesButton(userProfileProvider) {
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: () {},
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            children: [
              const Icon(
                Icons.mail,
                color: Colors.deepPurple,
              ),
              userProfileProvider.hasMessages ? 
              SvgPicture.asset('assets/svg/heart.svg',
                      width: 10.0,
                      colorFilter:
                          const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                    ) : 
              SvgPicture.asset(
                      'assets/svg/heart.svg',
                      width: 10.0,
                      colorFilter:
                          const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    )
            ],
          ),
        ]),
      ),
    );
  }

  Widget renderNotificationsButton(userProfileProvider) {
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: () {},
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.deepPurple,
              ),
              userProfileProvider.hasNotifications ? 
              SvgPicture.asset('assets/svg/heart.svg',
                width: 10.0,
                colorFilter:
                    const ColorFilter.mode(Colors.red, BlendMode.srcIn),
              ) : 
              SvgPicture.asset(
                'assets/svg/heart.svg',
                width: 10.0,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              )
            ],
          ),
        ]),
      ),
    );
  }

  Widget renderSideMenuButton() {
    return Expanded(
      flex: 1,
      child: TextButton(
        onPressed: () {
          widget.openDrawer();
        },
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Widget renderLinkAccountButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: SizedBox(
        child: Column(
          children: [
            const Padding(
              padding:  EdgeInsets.only(left:20.0, right: 20.0, bottom: 20.0),
              child: SizedBox(
                child: Text(
                  'You appear to be Single. Not true? Link your account with your partners account to show the world who your heart belongs to and start sharing your sweetest moments together with the world!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Get.to(() => GenerateCodeScreen());
              },
              child: const Text('Generate a Link Code',
                style:TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text("or", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Get.to(() => InputCodeScreen());
              },
              child: const Text(
                'Link accounts',
                style:
                    TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget renderPartnerProfilePicture(userProfileProvider) {
    return GestureDetector(
      onTap: () {
        Get.to(() => LargerPreviewScreen(
                image: userProfileProvider.partnerProfilePicture,
                postId: 000,
                isMyPost: false),
                opaque: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          child: SizedBox(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      color: Colors.purple),
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(userProfileProvider.partnerProfilePicture),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderRelationshipStageButton(userProfileProvider){
    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
      ),
      height: 40.0,
      child: ElevatedButton(
      onPressed: () {
        // TODO: trigger show relationship stage options toggle:
      },
      child: SizedBox(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(userProfileProvider.couple["relationship_status"],
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w400,
                  )
                )
              ),
              Container(
                margin: const EdgeInsets.only(left: 5.0),
                child: userProfileProvider.couple["relationship_status"] == 'Dating' ?  // TODO: make this a function that determines the svg to use:
                SvgPicture.asset('assets/svg/twohearts.svg',
                  width: 15.0,
                  colorFilter: const ColorFilter.mode(
                    Colors.redAccent, BlendMode.srcIn
                  ),
                ) : 
                userProfileProvider.couple["relationship_status"] == 'Engaged' ? 
                SvgPicture.asset('assets/svg/rings1.svg',
                  width: 15.0,
                  colorFilter: const ColorFilter.mode(
                  Colors.blue, BlendMode.srcIn
                  ),
                ) :
                userProfileProvider.couple["relationship_status"] == 'Married' ? 
                SvgPicture.asset('assets/svg/rings2.svg',
                  width: 15.0,
                  colorFilter: const ColorFilter.mode(
                    Colors.pink, BlendMode.srcIn
                  ),
                ) : 
                const SizedBox(),
              )
            ],
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) => userProfileProvider.loadingPage ?
        // loading icon:
        renderLoadingIcon()
        :
        // main profile page:
        SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [

                // user details:
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
          
                      // sexual orientation:
                      renderOrientation(),
          
                      // profile picture:
                      renderProfilePicture(userProfileProvider),
          
                      // relationship status:
                      renderRelationShipStatus(userProfileProvider),
          
                    ],
                  ),
                ),
          
                // username:
                Container(padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    userProfileProvider.userProfile['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16.0,
                    ),
                  ),
                ),

                // user button functions:
                Container(
                  height: 50.0,
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [

                      // couple explorer button:
                      renderCoupleExplorerButton(),
          
                      // messages button:
                      renderMessagesButton(userProfileProvider),
          
                      // notifications button:
                      renderNotificationsButton(userProfileProvider),
          
                      // side menu button:
                      renderSideMenuButton(),

                    ],
                  ),
                ),
          
                const Divider(
                  thickness: 1.0,
                  indent: 60.0,
                  endIndent: 60.0,
                ),
          
                // link account buttons:
                userProfileProvider.couple.isEmpty ? 
                renderLinkAccountButtons() :
        
                // in a relationship title:
                const SizedBox(
                  child: Text(
                    'In a relationship with:',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
        
                // partner and relationship details:
                userProfileProvider.couple.isEmpty ? 
                const SizedBox() :
                // relationship partner section:
                SizedBox(
                child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding:const EdgeInsets.all(2.0),
                          color: Colors.white,
                          child: Column(
                          children: [

                            // partner profile picture:
                            renderPartnerProfilePicture(userProfileProvider),
          
                            // partner username:
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                child: Container(
                                  child: Text(userProfileProvider.userProfile["my_partner"]['username'],
                                    style: const TextStyle(fontWeight: FontWeight.w300)
                                  )
                                ),
                              ),
                            ),
          
                            const SizedBox(
                              height: 5.0,
                            ),
          
                            // relationship stage button:
                            renderRelationshipStageButton(userProfileProvider)            
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
                                              userProfileProvider
                                                  .couple[
                                                      "admirers"]
                                                  .toString(),
                                              style:
                                                  const TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w300,
                                              )),
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
                                                .w500,
                                        color: Colors
                                            .deepPurpleAccent)),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                        5.0),
                                child: Text(
                                  userProfileProvider
                                          .couple[
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
                                                .w500,
                                        color: Colors
                                            .deepPurpleAccent)),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                        5.0),
                                child: Text(
                                  userProfileProvider
                                          .couple[
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
                  userProfileProvider
                          .showRelationshipStageOptions
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
                                            // TODO: trigger show relationship stage options toggle:
                                          },
                                          child: Text(
                                              'Dating',
                                              style: TextStyle(
                                                  color: userProfileProvider.couple["relationship_status"] ==
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
                                                  color: userProfileProvider.couple["relationship_status"] ==
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
                                                  color: userProfileProvider.couple["relationship_status"] ==
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
                      userProfileProvider.couple.isEmpty
                          ? Container()
                          : Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  await Future.delayed(
                                      const Duration(
                                          milliseconds: 500));
                                  // Get.to(
                                  //     () => ListAdmirersScreen());
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
                                        color:
                                            Colors.deepPurpleAccent,
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
                                    child: Text(userProfileProvider
                                        .couple["admirers"]
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
                                  color: Colors.deepPurpleAccent,
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
                                  userProfileProvider.userProfile[
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
                                      if (userProfileProvider
                                          .couple.isNotEmpty) {
                                        // Get.off(() =>
                                        //     CreateAPostScreen(
                                        //         resetPageFunction:
                                        //             () {}));
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
                userProfileProvider.couple["has_posts"] == false || 
                userProfileProvider.couple.isEmpty ? 
                Container() :
                // POST GALLERY
                Container(
                child: Column(
                children: [
                // IMAGE LIST
                Container(
                height: 450.0,
                child: Container(
                padding: const EdgeInsets.all(2.0),
                height: 30.0,
                child: GridView.builder(
                  itemCount: userProfileProvider.couplePosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) {
                  return TextButton(style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                  onPressed: () {
                    String image = userProfileProvider.couplePosts[index]["post_image"];
                    Get.to(()=>LargerPreviewScreen(image: image, postId: 000, isMyPost: false), opaque: false);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                    image: DecorationImage(
                    image: NetworkImage(
                    userProfileProvider.couplePosts[index]["post_image"]
                    ),
                    fit: BoxFit.cover),
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
          ))),
    );
  }
}
