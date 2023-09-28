import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/custombutton.dart';

import '../../utils/pageutils.dart';
import 'api/commentsapi.dart';

class Comment extends StatefulWidget {
  final Map commentData;
  final Function removeDeletedCommentFunction;
  const Comment(
      {Key? key,
      required this.commentData,
      required this.removeDeletedCommentFunction})
      : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> with TickerProviderStateMixin {
  bool deletingComment = false;
  final RxBool isLiked = RxBool(false);
  final RxInt commentLikes = RxInt(0);
  final RxBool showDelete = RxBool(false);
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
    isLiked.value = widget.commentData["comment_liked"];
    pageData.value = {
      "ownerUsername": widget.commentData["comment"]["owner"]["username"],
      "ownerProfilePicture": widget.commentData["comment"]["owner"]
          ["profile_picture"],
      "comment": decodeComment(widget.commentData["comment"]["comment"])
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

  void deleteComment(commentId) async {
    if (deletingComment == false) {
      deletingComment = true;
      Map apiResponse = await deleteCommentService(commentId);
      if (apiResponse["api_response"] == "success") {
        await widget.removeDeletedCommentFunction(widget.commentData);
        SnackBars().displaySnackBar("Comment Deleted!", () {}, context);
        deletingComment = false;
      } else {
        SnackBars().displaySnackBar(
            "Something went wrong. We'll fix it soon!", () {}, context);
        deletingComment = false;
      }
    } else {
      SnackBars().displaySnackBar(
          "Please wait for the delete process to complete.", () {}, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDelete.value ? showDelete.value = false : showDelete.value = true;
      },
      onTap: () {
        showDelete.value ? showDelete.value = false : null;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 10.0),
        child: SizedBox(
          child: Row(children: [
            // commentors profile picture:
            Expanded(
                flex: 1,
                child: Container(
                  height: 80.0,
                  alignment: Alignment.center,
                  child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          color: Colors.purpleAccent),
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        radius: 10.0,
                        backgroundImage: pageData["ownerProfilePicture"] != null
                            ? NetworkImage(pageData["ownerProfilePicture"])
                            : const NetworkImage(
                                "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png"),
                      )),
                )),

            // comment data:
            Expanded(
                flex: 3,
                child: SizedBox(
                  height: 80.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // username:
                      Container(
                        height: 16.0,
                        padding: const EdgeInsets.only(
                          left: 5.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pageData["ownerUsername"],
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                      // comment text:
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pageData["comment"],
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      // comment like button:
                      SizedBox(
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
                                    Obx(
                                      () => AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        transitionBuilder:
                                            ((child, animation) =>
                                                FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                )),
                                        child: SizedBox(
                                          width: 20.0,
                                          key: ValueKey<bool>(isLiked.value),
                                          child: isLiked.value
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Transform(
                                                    child: Image.asset(
                                                      'assets/placeholders/logo.jpeg',
                                                      width: 15.0,
                                                    ),
                                                    alignment: Alignment.center,
                                                    transform:
                                                        Matrix4.rotationZ(6.0),
                                                  ),
                                                )
                                              : SvgPicture.asset(
                                                  'assets/svg/heart.svg',
                                                  alignment: Alignment.center,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Color.fromRGBO(
                                                              158, 158, 158, 1),
                                                          BlendMode.srcIn),
                                                  width: 20.0,
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Obx(
                                      () => Text(commentLikes.value.toString(),
                                          style:
                                              const TextStyle(fontSize: 12.0)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // delete button:
                      Obx(() => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                          child: showDelete.value
                              ? Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0))),
                                  alignment: Alignment.center,
                                  child: CustomButton(
                                      onpressedfunction: () {
                                        deleteComment(widget
                                            .commentData["comment"]["id"]);
                                      },
                                      borderradius: 10.0,
                                      buttonlabel: "",
                                      buttoncolor: Colors.transparent,
                                      splashcolor: Colors.blue,
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.purple,
                                      )),
                                )
                              : const SizedBox()))
                    ],
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
