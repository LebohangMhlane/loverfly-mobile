import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/screens/commentsscreen/commentreply.dart';

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
  bool isLiked = false;
  final RxInt commentLikes = RxInt(0);
  final RxBool showOptions = RxBool(false);
  bool isMyComment = false;
  String ownerProfilePicture = "";
  String username = "";
  String comment = "";
  bool isCommentReply = false;

  @override
  void initState() {
    preparePageData();
    super.initState();
  }

  void preparePageData() {
    isLiked = widget.commentData["comment_liked"];
    if (widget.commentData.containsKey("comment")) {
      username = widget.commentData["comment"]["owner"]["username"];
      ownerProfilePicture = widget.commentData["comment"]["owner"]
                  ["profile_picture"] !=
              null
          ? widget.commentData["comment"]["owner"]["profile_picture"]["image"]
          : "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png";
      comment = decodeComment(widget.commentData["comment"]["comment"]);
      commentLikes.value = widget.commentData["comment"]["comment_likes"];
    } else {
      isCommentReply = true;
      username = widget.commentData["comment_reply"]["replier"]["username"];
      ownerProfilePicture = widget.commentData["comment_reply"]["replier"]
                  ["profile_picture"] !=
              null
          ? widget.commentData["comment_reply"]["replier"]["profile_picture"]
              ["image"]
          : "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png";
      comment =
          decodeComment(widget.commentData["comment_reply"]["comment_reply"]);
      commentLikes.value = widget.commentData["comment_reply_likes"];
    }
  }

  // EMOJIIIIISSS!!!!!!
  String decodeComment(String comment) {
    var commentAsBytes = comment.codeUnits;
    String decodedCode = utf8.decode(commentAsBytes, allowMalformed: true);
    return decodedCode;
  }

  void likeUnlikeComment() async {
    Map apiResponse =
        await likeComment(widget.commentData["comment"]["id"], isLiked);
    if (apiResponse["api_response"] == "success") {
      isLiked = apiResponse["comment_liked"];
      widget.commentData["comment_liked"] = apiResponse["comment_liked"];
      isLiked
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

  void likeUnlikeCommentReply() async {}

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
                    backgroundImage: NetworkImage(ownerProfilePicture),
                  )),
            ),
          ),

          // comment data:
          Expanded(
              flex: 5,
              child: SizedBox(
                height: 90.0,
                child: Obx(
                  () => Stack(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // username:
                        Container(
                          height: 20.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                            gradient: LinearGradient(
                              colors: [
                                !isCommentReply ? Colors.purple : Colors.blue,
                                Colors.white
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            left: 5.0,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            username,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        ),
                        // comment text:
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              comment,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        // comment functions:
                        !isMyComment
                            ? Expanded(
                                child: SizedBox(
                                  child: Padding(
                                    padding: isCommentReply
                                        ? const EdgeInsets.only(right: 30.0)
                                        : const EdgeInsets.only(right: 12.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // like comment button:
                                          SizedBox(
                                            width: 40.0,
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3.0),
                                                ),
                                                onPressed: () {
                                                  !isCommentReply
                                                      ? likeUnlikeComment()
                                                      : likeUnlikeCommentReply();
                                                },
                                                child: SizedBox(
                                                  child: Row(
                                                    children: [
                                                      AnimatedSwitcher(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        transitionBuilder:
                                                            ((child,
                                                                    animation) =>
                                                                FadeTransition(
                                                                  opacity:
                                                                      animation,
                                                                  child: child,
                                                                )),
                                                        child: SizedBox(
                                                          width: 21.0,
                                                          key: ValueKey<bool>(
                                                              isLiked),
                                                          child: isLiked
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1.0),
                                                                  child:
                                                                      Transform(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/placeholders/logo.jpeg',
                                                                      width:
                                                                          18.0,
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    transform: Matrix4
                                                                        .rotationZ(
                                                                            6.0),
                                                                  ),
                                                                )
                                                              : SvgPicture
                                                                  .asset(
                                                                  'assets/svg/heart.svg',
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  colorFilter: const ColorFilter
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
                                                        width: 4.0,
                                                      ),
                                                      Text(
                                                          commentLikes.value
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .purple)),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          // reply to comment:
                                          !isCommentReply
                                              ? SizedBox(
                                                  width: 40.0,
                                                  child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                      ),
                                                      onPressed: () async {
                                                        await Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        500))
                                                            .then((value) =>
                                                                Get.to(
                                                                    () =>
                                                                        CommentReplyScreen(
                                                                          commentData:
                                                                              widget.commentData,
                                                                        ),
                                                                    opaque:
                                                                        false));
                                                      },
                                                      child: const SizedBox(
                                                        child: Icon(
                                                          Icons.chat,
                                                          size: 18.0,
                                                          color: Colors.purple,
                                                        ),
                                                      )),
                                                )
                                              : const SizedBox()
                                        ]),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ]),
                ),
              )),
        ]),
      ),
    );
  }
}
