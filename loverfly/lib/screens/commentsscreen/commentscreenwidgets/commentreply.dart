import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loverfly/screens/commentsscreen/api/commentsapi.dart';
import 'package:loverfly/screens/commentsscreen/commentscreenwidgets/comment.dart';
import 'package:loverfly/screens/commentsscreen/commentscreenwidgets/commentinput.dart';

// TODO: fix the immutable issue later:
// ignore: must_be_immutable
class CommentReplyScreen extends StatelessWidget {
  CommentReplyScreen({Key? key, required this.commentData}) : super(key: key);

  final Map commentData;
  String profilePicture = "";
  String username = "";
  String comment = "";
  final RxList commentReplies = RxList([{}]);
  final RxBool loading = RxBool(true);

  void preparePageData() async {
    profilePicture = commentData["comment"]["owner"]["profile_picture"] != null
        ? commentData["comment"]["owner"]["profile_picture"]["image"]
        : "";
    username = commentData["comment"]["owner"]["username"];
    comment = comment = decodeComment(commentData["comment"]["comment"]);
    getCommentReplies();
  }

  void getCommentReplies() async {
    Map repliesFromServer =
        await getCommentRepliesFromServer(commentData["comment"]["id"]);
    commentReplies.value = repliesFromServer["comment_replies"];
    loading.value = false;
  }

  void replyToComment(commentId, commentReply) async {
    Map response = await replyToCommentServer(commentId, commentReply);
    commentReplies.add(response["comment_reply"]);
  }

  // TODO: move this function to a file so it can be accessed globally. It is being used more than once:
  String decodeComment(String comment) {
    var commentAsBytes = comment.codeUnits;
    String decodedCode = utf8.decode(commentAsBytes, allowMalformed: true);
    return decodedCode;
  }

  @override
  Widget build(BuildContext context) {
    preparePageData();
    return Scaffold(
        backgroundColor: const Color.fromARGB(160, 0, 0, 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 80.0,
              ),
              Container(
                  height: 600.0,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Obx(
                    () => !loading.value
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              // replying to text:
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        "Replying to:",
                                        style: TextStyle(color: Colors.purple),
                                      ))),
                              const SizedBox(
                                height: 20.0,
                              ),
                              // comment being replied to:
                              SizedBox(
                                child: Row(children: [
                                  SizedBox(
                                    width: 100.0,
                                    child: Center(
                                      child: Container(
                                          width: 60.0,
                                          height: 60.0,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                              color: Colors.purpleAccent),
                                          padding: const EdgeInsets.all(1.0),
                                          child: const CircleAvatar(
                                            radius: 10.0,
                                            backgroundImage: NetworkImage(
                                                "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png"),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: SizedBox(
                                        height: 60.0,
                                        child: Stack(children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // username:
                                              Container(
                                                height: 20.0,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10.0)),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.purple,
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
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              // comment text:
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 8.0),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    comment,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      )),
                                ]),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              // comment replies list:
                              Expanded(
                                  flex: 6,
                                  child: Obx(
                                    () => ListView.builder(
                                      itemCount: commentReplies.length,
                                      itemBuilder: ((context, index) {
                                        return Comment(
                                            commentData: commentReplies[index],
                                            commentIndex: index);
                                      }),
                                    ),
                                  )),
                              Expanded(
                                child: SizedBox(
                                  height: 30.0,
                                  child: CommentInput(
                                      isReplying: true,
                                      postCommentFunction: replyToComment,
                                      postId: commentData.containsKey("comment")
                                          ? commentData["comment"]["id"]
                                          : commentData["comment_reply"]["id"]),
                                ),
                              )
                            ],
                          )
                        : const Center(
                            child: SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                  )),
            ],
          ),
        ));
  }
}
