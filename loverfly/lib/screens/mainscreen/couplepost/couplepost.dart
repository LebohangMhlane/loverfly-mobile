// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_this, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, avoid_print

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/screens/commentsscreen/commentsmainscreen.dart';
import 'package:loverfly/screens/couplescreen/viewcouple.dart';
import 'package:loverfly/screens/largerpreviewscreen/largerpreviewscreen.dart';
import 'package:loverfly/screens/mainscreen/mainpageprovider.dart';
import 'package:loverfly/utils/utils.dart';
import 'package:loverfly/userinteractions/admire/admireapi.dart';
import 'package:loverfly/userinteractions/like/likeapi.dart';
import 'package:provider/provider.dart';

class CouplePost extends StatefulWidget {
  final Map postdata;
  final Function rebuildPageFunction;
  final Function updateCommentCountMain;
  final int postIndex;
  const CouplePost({
    required this.postdata,
    required this.rebuildPageFunction,
    required this.updateCommentCountMain,
    required this.postIndex,
  });

  @override
  State<CouplePost> createState() => _CouplePostState();
}

// TODO: remove getx setup in stateful widgets:

class _CouplePostState extends State<CouplePost> {
  // prepare the data
  final RxMap post = RxMap({});

  final RxMap couple = RxMap({});

  final Rx<bool> isliked = RxBool(false);

  final RxBool isAdmired = RxBool(false);

  final RxMap postdate = RxMap({});

  final RxInt admirers = RxInt(0);

  final RxInt likecount = RxInt(0);

  final RxInt commentCount = RxInt(0);

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
      post.value = widget.postdata["post"];
      couple.value = widget.postdata["couple"];
      isliked.value = widget.postdata["isLiked"];
      isAdmired.value = widget.postdata["isAdmired"];
      postdate.value = DateFunctions().convertdate(post["time_posted"]);
      admirers.value = couple["admirers"];
      likecount.value = post["likes"];
      commentCount.value = widget.postdata["comments_count"];
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

  // TODO: remember to remove getx:
  void updateCommentCount(bool increment) {
    widget.updateCommentCountMain(increment, widget.postIndex);
    setState(() {
      increment
          ? commentCount.value = commentCount.value + 1
          : commentCount.value = commentCount.value - 1;
    });
  }

  @override
  void initState() {
    preparePageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) => Container(
        child: Column(children: [
        // profile picture and admirers section:
        GestureDetector(
          onTap: () {
            Get.to(() => CoupleProfileScreen(
              coupleId: couple["id"], 
              isAdmired: false, 
              rebuildPageFunction: (){},
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
                                      image: postProvider.profilePictureOne,
                                      postId: 000,
                                      isMyPost: false,
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
                                          NetworkImage(postProvider.profilePictureOne),
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
                                          image: postProvider.profilePictureTwo,
                                          postId: 000,
                                          isMyPost: false,
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
                                      backgroundImage: NetworkImage(postProvider.profilePictureTwo),
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
                                  text: postProvider.userNameOne,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black)),
                              const TextSpan(
                                  text: " + ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      color: Colors.black)),
                              TextSpan(
                                  text: postProvider.userNameTwo,
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
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                postProvider.admirerCount.toString(),
                                style:
                                    const TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
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
                            image: post["post_image"],
                            postId: post["id"],
                            isMyPost: widget.postdata["is_my_post"]),
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
            !widget.postdata["is_my_post"]
                ? Container(
                    width: 130.0,
                    child: TextButton(
                      onPressed: () async {
                        await admire(couple["id"], widget.postdata["isAdmired"])
                            .then((response) {
                          widget.postdata["isAdmired"] = response["admired"];
                          isAdmired.value = response["admired"];
                          if (response["admired"] == false) {
                            if (admirers.value != 0) {
                              admirers.value--;
                              widget.postdata["couple"]["admirers"]--;
                            }
                          } else {
                            admirers.value++;
                            widget.postdata["couple"]["admirers"]++;
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
                            Container(
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
            !widget.postdata["is_my_post"]
                ? Expanded(
                    child: TextButton(
                      onPressed: () {
                        likePost(post["id"], isliked.value).then((value) {
                          widget.postdata["isliked"] = value;
                          isliked.value = value;
                          if (value == false) {
                            likecount.value != 0 ? likecount.value-- : null;
                            widget.postdata["post"]["likes"]--;
                          } else {
                            likecount.value++;
                            widget.postdata["post"]["likes"]++;
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
                            Container(
                            padding: const EdgeInsets.only(
                            left: 6.0, bottom: 3.0),
                            child: Icon(
                              Icons.thumb_up,
                              color: postProvider.isLiked
                              ? Colors.purple[800]
                              : Colors.grey[300],
                              size: 17.0,
                            )),
      
                            // like count
                            Container(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Text(
                                postProvider.likeCount,
                                style: const TextStyle(color: Colors.black, fontSize: 11.0),
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
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 500))
                      .then((value) {
                    print(value);
                    Get.to(() => CommentScreen(
                      updateCommentCount: updateCommentCount,
                      postId: post["id"],
                      couple: couple,
                    ));
                  });
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.comment,
                          color: Colors.purple[800],
                          size: 20.0,
                        ),
                      ),
                      Text(
                        postProvider.commentCount,
                        style:
                            const TextStyle(fontSize: 11.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ])),
    );
  }
}