// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_this, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, avoid_print

import 'package:http/http.dart' as http;
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
  final Function rebuildPageFunction;
  CouplePost({required this.postdata, required this.rebuildPageFunction});

  // prepare the data
  final RxMap post = RxMap({});

  final RxMap couple = RxMap({});

  final Rx<bool> isliked = RxBool(false);

  final RxBool isAdmired = RxBool(false);

  final RxMap postdate = RxMap({});

  final RxInt admirers = RxInt(0);

  final RxInt likecount = RxInt(0);

  final RxDouble imageHeight = RxDouble(0.0);

  final RxBool pageLoaded = RxBool(false);

  String partnerOneProfilePicture = "";
  String partnerTwoProfilePicture = "";

  // gets the image from aws s3 storage bucket:
  Future<http.Response> fetchImage(String imageUrl) async {
    Uri url = Uri.parse(imageUrl);
    final response = await http.get(url);
    return response;
  }

  void preparePageData() {
    if (!pageLoaded.value) {
      post.value = postdata["post"];
      couple.value = postdata["couple"];
      isliked.value = postdata["isLiked"];
      isAdmired.value = postdata["isAdmired"];
      postdate.value = DateFunctions().convertdate(post["time_posted"]);
      admirers.value = couple["admirers"];
      likecount.value = post["likes"];
      imageHeight.value = 0.0;
      pageLoaded.value = true;
      partnerOneProfilePicture = couple["partner_one"]["profile_picture"] !=
              null
          ? couple["partner_one"]["profile_picture"]["image"]
          : "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png";
      partnerTwoProfilePicture = couple["partner_two"]["profile_picture"] !=
              null
          ? couple["partner_two"]["profile_picture"]["image"]
          : "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    preparePageData();
    return Container(
        child: Column(children: [
      // profile picture and admirers section:
      GestureDetector(
        onTap: () {
          Get.to(() => CoupleProfileScreen(
                couple: couple,
                isAdmired: RxBool(postdata["isAdmired"]),
                rebuildPageFunction: rebuildPageFunction,
              ));
        },
        child: SizedBox(
          height: 100.0,
          child: Row(
            children: [
              // profile pictures:
              SizedBox(
                  width: 121.0,
                  height: 110.0,
                  child: Center(
                    child: Container(
                      child: Stack(
                        children: [
                          // couple partner 1 profile picture:
                          Positioned(
                            left: 60.0,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                  () => LargerPreviewScreen(
                                        imageurl: partnerOneProfilePicture,
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
                                    backgroundImage:
                                        NetworkImage(partnerOneProfilePicture),
                                    radius: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // couple partner 2 profile picture:
                          Positioned(
                            top: 25.0,
                            right: 40.0,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                  () => LargerPreviewScreen(
                                        imageurl: partnerTwoProfilePicture,
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
                                    backgroundImage:
                                        NetworkImage(partnerTwoProfilePicture),
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

              // usernames:
              Expanded(
                flex: 6,
                child: SizedBox(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
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
              ),

              // top right corner admirers section:
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          child: SvgPicture.asset(
                        'assets/svg/heart.svg',
                        width: 14.0,
                        colorFilter: const ColorFilter.mode(
                            Colors.lightBlue, BlendMode.srcIn),
                      )),
                      Obx(
                        () => Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              couple["admirers"].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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
              GestureDetector(
                  onTap: () => Get.to(
                      () => LargerPreviewScreen(
                            imageurl: post["post_image"] ?? "",
                            myImage: false,
                            postId: 000,
                            resetPage: () {},
                          ),
                      opaque: false),
                  child: Container(
                    height: 350.0,
                    width: MediaQuery.of(context).size.width,
                    child: Transform.scale(
                        scale: 1.0,
                        child: FadeInImage.assetNetwork(
                          fadeInDuration: const Duration(milliseconds: 250),
                          fit: BoxFit.cover,
                          placeholder: "assets/placeholders/loadingImage.gif",
                          image: post["post_image"] ?? "",
                        )),
                  )),

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
        height: 80.0,
        child: Row(children: [
          // admire couple button:
          !postdata["is_my_post"]
              ? Container(
                  width: 130.0,
                  child: TextButton(
                    onPressed: () async {
                      await admire(couple["id"], postdata["isAdmired"])
                          .then((response) {
                        postdata["isAdmired"] = response["admired"];
                        isAdmired.value = response["admired"];
                        if (response["admired"] == false) {
                          if (admirers.value != 0) {
                            admirers.value--;
                            postdata["couple"]["admirers"]--;
                          }
                        } else {
                          admirers.value++;
                          postdata["couple"]["admirers"]++;
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Text(
                              "Admire",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                          ),
                          Obx(
                            () => Container(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: isAdmired.value
                                  ?
                                  // admired heart icon
                                  Transform(
                                      child: Image.asset(
                                        'assets/placeholders/logo.jpeg',
                                        width: 20.0,
                                      ),
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationZ(6.0),
                                    )
                                  :
                                  // unAdmired heart heart icon
                                  SvgPicture.asset(
                                      'assets/svg/heart.svg',
                                      alignment: Alignment.center,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.grey, BlendMode.srcIn),
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
          !postdata["is_my_post"]
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
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // like text
                          Container(
                            child: const Text(
                              "Like",
                              style: TextStyle(
                                  fontSize: 12.0,
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
              child: const Center(
                child: SizedBox(
                  child: Icon(
                    Icons.comment,
                    color: Colors.purple,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    ]));
  }
}
