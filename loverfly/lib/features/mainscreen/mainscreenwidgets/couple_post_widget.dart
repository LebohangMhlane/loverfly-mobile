// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_this, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/features/comments/commentsmainscreen.dart';
import 'package:loverfly/features/view_couple_screen/viewcouple.dart';
import 'package:loverfly/features/largerpreviewscreen/largerpreviewscreen.dart';
import 'package:loverfly/features/mainscreen/mainscreenprovider/mainpageprovider.dart';
import 'package:loverfly/userinteractions/admire/admireapi.dart';
import 'package:loverfly/userinteractions/like/likeapi.dart';
import 'package:provider/provider.dart';

class CouplePostWidget extends StatefulWidget {

  const CouplePostWidget({ Key? key, });

  @override
  State<CouplePostWidget> createState() => _CouplePostWidgetState();
}

class _CouplePostWidgetState extends State<CouplePostWidget> {

  @override
  void initState() {
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
            Get.to(() => ViewCouple(
              couple: postProvider.couple,
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
                                      backgroundImage: NetworkImage(
                                          postProvider.profilePictureOne),
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
                                      backgroundImage: NetworkImage(
                                          postProvider.profilePictureTwo),
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
                          image: postProvider.postImage,
                          postId: postProvider.post["id"],
                          isMyPost: postProvider.isMyPost),
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
                        image: postProvider.post["post_image"],
                      )),
                  )
                ),

                // caption
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    margin: const EdgeInsets.only(bottom: 40.0),
                    child: Text(postProvider.post["caption"],
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
                              postProvider.date["normalized"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            postProvider.couple['is_verified']
                                ? 'Verified'
                                : '',
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
            postProvider.isMyPost == false
                ? Container(
                    width: 130.0,
                    child: TextButton(
                      onPressed: () async {
                        Map response = await admire(
                            postProvider.couple["id"], postProvider.isAdmired);
                        if (response.containsKey("admired")) {
                          postProvider.updateIsAdmired(response["admired"]);
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)
                          )
                        )
                      ),
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
                              child: postProvider.isAdmired
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

            // like button:
            postProvider.isMyPost == false
            ? Expanded(
                child: TextButton(
                  onPressed: () async {
                    bool isLiked = await likePost(
                        postProvider.post["id"], postProvider.isLiked
                      );
                    postProvider.updateLikes(isLiked);
                  },
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)
                      )
                    )
                  ),
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
                            style: const TextStyle(
                                color: Colors.black, fontSize: 11.0),
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
                  await Future.delayed(const Duration(milliseconds: 250))
                      .then((value) {
                    print(value);
                    Get.to(() => CommentScreen(
                      updateCommentCount: () {},
                      postId: 000,
                      couple: const {},
                    ));
                  });
                },
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)
                      )
                    )
                  ),
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
                        style: const TextStyle(
                            fontSize: 11.0, color: Colors.black),
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
