import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/custombutton.dart';

import '../../utils/pageutils.dart';
import 'api/commentsapi.dart';

class Comment extends StatefulWidget {
  final Map commentData;
  final int commentIndex;
  const Comment(
      {Key? key, required this.commentData, required this.commentIndex})
      : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> with TickerProviderStateMixin {
  bool deletingComment = false;
  final RxBool isLiked = RxBool(false);
  final RxInt commentLikes = RxInt(0);
  final RxBool showOptions = RxBool(false);
  bool isMyComment = false;
  final RxMap pageData = RxMap({
    "ownerUsername": "",
    "ownerProfilePicture": null,
    "comment": "",
  });

  @override
  void initState() {
    preparePageData();
    super.initState();
  }

  void preparePageData() {
    bool isliked = widget.commentData["comment_liked"];
    String username = widget.commentData["comment"]["owner"]["username"];
    Map ownerProfilePicture =
        widget.commentData["comment"]["owner"]["profile_picture"] ??
            {
              "image":
                  "https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg"
            };
    String comment = decodeComment(widget.commentData["comment"]["comment"]);

    // set the data and trigger the page update:
    isLiked.value = isliked;
    pageData.value = {
      "ownerUsername": username,
      "ownerProfilePicture": ownerProfilePicture,
      "comment": comment,
    };
    commentLikes.value = widget.commentData["comment"]["comment_likes"];
  }

  // EMOJIIIIISSS!!!!!!
  String decodeComment(String comment) {
    var commentAsBytes = comment.codeUnits;
    String decodedCode = utf8.decode(commentAsBytes, allowMalformed: true);
    return decodedCode;
  }

  void likeUnlikeComment() async {
    Map apiResponse =
        await likeComment(widget.commentData["comment"]["id"], isLiked.value);
    if (apiResponse["api_response"] == "success") {
      isLiked.value = apiResponse["comment_liked"];
      widget.commentData["comment_liked"] = apiResponse["comment_liked"];
      isLiked.value
          ? commentLikes.value++
          : commentLikes.value != 0
              ? commentLikes.value--
              : null;
    } else {
      SnackBars().displaySnackBar(
          "Something went wrong with Liking this comment. We're looking into it.",
          () {},
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        child: Row(children: [
          // commentors profile picture:
          SizedBox(
            width: 100.0,
            child: Center(
              child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      color: Colors.purpleAccent),
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundImage: pageData["ownerProfilePicture"]["image"] !=
                            null
                        ? NetworkImage(pageData["ownerProfilePicture"]["image"])
                        : const NetworkImage(
                            "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png"),
                  )),
            ),
          ),

          // comment data:
          Expanded(
              flex: 5,
              child: SizedBox(
                height: 80.0,
                child: Obx(
                  () => Stack(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // username:
                        Container(
                          height: 20.0,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            left: 5.0,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pageData["ownerUsername"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        ),
                        // comment text:
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              pageData["comment"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        // comment like button:
                        !isMyComment
                            ? SizedBox(
                                height: 20.0,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      likeUnlikeComment();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: SizedBox(
                                        width: 70.0,
                                        child: Row(
                                          children: [
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              transitionBuilder:
                                                  ((child, animation) =>
                                                      FadeTransition(
                                                        opacity: animation,
                                                        child: child,
                                                      )),
                                              child: SizedBox(
                                                width: 20.0,
                                                key: ValueKey<bool>(
                                                    isLiked.value),
                                                child: isLiked.value
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: Transform(
                                                          child: Image.asset(
                                                            'assets/placeholders/logo.jpeg',
                                                            width: 15.0,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          transform:
                                                              Matrix4.rotationZ(
                                                                  6.0),
                                                        ),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/svg/heart.svg',
                                                        alignment:
                                                            Alignment.center,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                Color.fromRGBO(
                                                                    158,
                                                                    158,
                                                                    158,
                                                                    1),
                                                                BlendMode
                                                                    .srcIn),
                                                        width: 20.0,
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Obx(
                                              () => Text(
                                                  commentLikes.value.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    showOptions.value
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 110.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 1.0)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(children: [
                                Expanded(
                                  child: CustomButton(
                                    buttonlabel: "Reply",
                                    textcolor: Colors.black,
                                    textfontsize: 12.0,
                                    buttoncolor: Colors.white,
                                    splashcolor: Colors.blue,
                                    onpressedfunction: () {
                                      setState(() {
                                        showOptions.value = false;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          )
                        : const SizedBox(),
                  ]),
                ),
              )),

          // show options button:
          Expanded(
              child: CustomButton(
                  onpressedfunction: () {
                    setState(() {
                      showOptions.value
                          ? showOptions.value = false
                          : showOptions.value = true;
                    });
                  },
                  borderradius: 10.0,
                  buttonlabel: "",
                  buttoncolor: Colors.transparent,
                  splashcolor: Colors.blue,
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.purple,
                    size: 20,
                  )))
        ]),
      ),
    );
  }
}
