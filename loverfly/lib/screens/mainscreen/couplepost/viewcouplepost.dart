// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_this, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/screens/largerpreviewscreen/largerpreviewscreen.dart';
import 'package:loverfly/utils/utils.dart';
import 'package:loverfly/userinteractions/favourite/favouriteapi.dart';
import 'package:loverfly/userinteractions/like/likeapi.dart';
import '../../commentsscreen/commentsmainscreen.dart';
import '../../couplescreen/viewcouple.dart';

class CouplePost extends StatelessWidget {
  final Map postdata;
  final Function resetPageFunction;
  const CouplePost({required this.postdata, required this.resetPageFunction});

  @override
  Widget build(BuildContext context) {
    // prepare the data and build:
    Map post = postdata["post"];
    Map couple = postdata["couple"];
    Rx<bool> isliked = Rx(postdata["isLiked"]);
    RxBool isFavourited = RxBool(postdata["isFavourited"]);
    Map postdate = DateFunctions().convertdate(post["time_posted"]);
    Rx<int> fans = Rx<int>(couple["fans"]);
    Rx<int> likecount = Rx<int>(post["likes"]);
    RxDouble imageHeight = RxDouble(0.0);

    return Container(
        child: Column(children: [
      // profile picture and favouriters section:
      GestureDetector(
        onTap: () {
          Get.to(() => CoupleProfileScreen(
                couple: couple,
                isfavourited: RxBool(postdata["isFavourited"]),
                rebuildPageFunction: resetPageFunction,
              ));
        },
        child: SizedBox(
          height: 100.0,
          child: Row(
            children: [
              // profile pictures
              SizedBox(
                  width: 120.0,
                  height: 110.0,
                  child: Center(
                    child: Container(
                      child: Stack(
                        children: [
                          // couple partner 1
                          Positioned(
                            left: 60.0,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                  () => LargerPreviewScreen(
                                        imageurl: couple["partner_one"]
                                            ["profile_picture"],
                                        myImage: false,
                                        resetPage: () {},
                                        postId: 000,
                                      ),
                                  opaque: false),
                              child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                      color: Colors.purple),
                                  padding: const EdgeInsets.all(1.0),
                                  width: 60.0,
                                  height: 60.0,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        couple["partner_one"]
                                            ["profile_picture"]),
                                    radius: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // couple partner 2
                          Positioned(
                            top: 25.0,
                            right: 40.0,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                  () => LargerPreviewScreen(
                                        imageurl: couple["partner_two"]
                                            ["profile_picture"],
                                        myImage: false,
                                        postId: 000,
                                        resetPage: () {},
                                      ),
                                  opaque: false),
                              child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.0)),
                                      color: Colors.purple),
                                  padding: const EdgeInsets.all(1.0),
                                  width: 60.0,
                                  height: 60.0,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        couple["partner_two"]
                                            ["profile_picture"]),
                                    radius: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              SizedBox(
                width: 199.0,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: couple["partner_one"]["username"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black)),
                          const TextSpan(
                              text: " + ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black)),
                          TextSpan(
                              text: couple["partner_two"]["username"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black)),
                        ]),
                      ),
                    )),
              ),

              // fans
              Expanded(
                child: Column(
                  children: [
                    const Expanded(
                        child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Fans",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12.0),
                        ),
                      ),
                    )),
                    Expanded(
                        child: SvgPicture.asset(
                      'assets/svg/heart.svg',
                      width: 14.0,
                      color: Colors.lightBlue,
                    )),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          couple["fans"].toString(),
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),

      // posted image:
      Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // image:
              LayoutBuilder(builder: (context, constraints) {
                double maxHeight = 550.0;
                BoxFit boxFit = BoxFit.fill;
                bool isMaxHeightReached = constraints.maxHeight >= maxHeight;
                if (isMaxHeightReached) {
                  boxFit;
                }
                imageHeight.update((val) {
                  val = constraints.maxHeight;
                });
                return GestureDetector(
                  onTap: () => Get.to(
                      () => LargerPreviewScreen(
                            imageurl: post["image"],
                            myImage: false,
                            postId: 000,
                            resetPage: () {},
                          ),
                      opaque: false),
                  child: Container(
                    // alignment: showComments.value ? Alignment.center : Alignment.bottomCenter,
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    width: MediaQuery.of(context).size.width,
                    child: Transform.scale(
                        scale: 1.0,
                        child: Image.network(
                          post["image"],
                          fit: BoxFit.cover,
                        )),
                  ),
                );
              }),

              // caption
              Opacity(
                opacity: 0.6,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  margin: const EdgeInsets.only(bottom: 40.0),
                  child: Text(post['caption'],
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),

              // time, date and verification
              Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(
                      bottom: 12.0, right: 15.0, left: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            postdate['dayofweek'].toString() +
                                ' - ' +
                                postdate['date'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12.0),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          couple['is_verified'] ? 'Verified' : '',
                          style: const TextStyle(
                            color: Colors.purple,
                            shadows: <Shadow>[
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          )
        ],
      ),

      // user interactions:
      Container(
        height: 110.0,
        child: Row(children: [
          // favourite couple button
          !postdata.containsKey("is_my_post")
              ? Container(
                  width: 130.0,
                  child: TextButton(
                    onPressed: () async {
                      await favourite(couple["id"], postdata["isFavourited"])
                          .then((response) {
                        postdata["isFavourited"] = response["favourited"];
                        isFavourited.value = response["favourited"];
                        if (response["favourited"] == false) {
                          if (fans.value != 0) {
                            fans.value--;
                            postdata["couple"]["fans"]--;
                          }
                        } else {
                          fans.value++;
                          postdata["couple"]["fans"]++;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            child: const Text(
                              "Favourite",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                          ),
                          Obx(
                            () => Container(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: isFavourited.value
                                  ?
                                  // favourited heart icon
                                  Transform(
                                      child: Image.asset(
                                        'assets/placeholders/logo.jpeg',
                                        width: 17.0,
                                      ),
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationZ(6.0),
                                    )
                                  :
                                  // unfavourited heart heart icon
                                  SvgPicture.asset(
                                      'assets/svg/heart.svg',
                                      alignment: Alignment.center,
                                      color: Colors.grey[300],
                                      width: 20.0,
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),

          const VerticalDivider(
            indent: 26.0,
            endIndent: 26.0,
            thickness: 1.0,
            width: 1.0,
          ),

          // like button
          !postdata.containsKey("is_my_post")
              ? Expanded(
                  child: TextButton(
                    onPressed: () {
                      likePost(post["id"], isliked.value).then((value) {
                        postdata["isliked"] = value;
                        isliked.value = value;
                        if (value == false) {
                          likecount.value != 0 ? likecount.value-- : null;
                          postdata["post"]["likes"]--;
                        } else {
                          likecount.value++;
                          postdata["post"]["likes"]++;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          // like text
                          Container(
                            child: const Text(
                              "Like",
                              style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                          ),

                          // like icon
                          Obx(
                            () => Container(
                                padding: const EdgeInsets.only(
                                    left: 6.0, bottom: 3.0),
                                child: Icon(
                                  Icons.thumb_up,
                                  color: isliked.value
                                      ? Colors.purple[800]
                                      : Colors.grey[300],
                                  size: 17.0,
                                )),
                          ),

                          // like count
                          Container(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: Obx(
                              () => Text(
                                likecount.value.toString(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 11.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),

          const VerticalDivider(
            indent: 26.0,
            endIndent: 26.0,
            thickness: 1.0,
            width: 1.0,
          ),

          // comment button:
          Expanded(
            child: TextButton(
              onPressed: () {
                Get.to(() => CommentScreen(
                      postId: post["id"],
                      couple: couple,
                    ));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 5.0),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.comment,
                  color: Colors.purple,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ]),
      ),
    ]));
  }
}
