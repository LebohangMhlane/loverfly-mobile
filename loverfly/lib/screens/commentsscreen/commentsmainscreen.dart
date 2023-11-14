import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/screens/commentsscreen/commentinput.dart';
import 'package:loverfly/utils/pageutils.dart';

import '../largerpreviewscreen/largerpreviewscreen.dart';
import 'api/commentsapi.dart';
import 'comment.dart';

class CommentScreen extends StatefulWidget {
  final int postId;
  final Map couple;
  final Function updateCommentCount;

  const CommentScreen({
    Key? key,
    required this.postId,
    required this.couple,
    required this.updateCommentCount,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List comments = [];
  final RxBool preventRebuildProcess = RxBool(false);
  bool pageLoading = true;
  String nextPageLink = "";
  bool deletingComment = false;
  String partnerOneProfilePicture = "";
  String partnerTwoProfilePicture = "";

  void preparePageData() async {
    if (!preventRebuildProcess.value) {
      var apiResponse = await getComments(widget.postId, "");
      if (apiResponse["api_response"] == "Success") {
        comments.addAll(apiResponse["comments"]);
        nextPageLink = apiResponse["next_page_link"] ?? "";
      }
      partnerOneProfilePicture = widget.couple["partner_one"]
                  ["profile_picture"] !=
              null
          ? widget.couple["partner_one"]["profile_picture"]["image"]
          : "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png";
      partnerTwoProfilePicture = widget.couple["partner_two"]
                  ["profile_picture"] !=
              null
          ? widget.couple["partner_two"]["profile_picture"]["image"]
          : "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png";
      setState(() {
        pageLoading = false;
        preventRebuildProcess.value = true;
      });
    }
  }

  void postAComment(postId, commentData) async {
    var apiResponse = await postComment(postId, commentData);
    apiResponse["api_response"] == "Success"
        ? comments
            .add({"comment_liked": false, "comment": apiResponse["comment"]})
        : null;
    widget.updateCommentCount(true);
    setState(() {});
  }

  Future<bool> checkIfMyComment(comment) async {
    var cache = GetStorage();
    Map myProfile = jsonDecode(cache.read("user_profile"));
    if (myProfile["username"] == comment["comment"]["owner"]["username"]) {
      return true;
    }
    return false;
  }

  Future<bool> deleteComment(commentId) async {
    if (deletingComment == false) {
      deletingComment = true;
      Map apiResponse = await deleteCommentService(commentId);
      if (apiResponse["api_response"] == "success") {
        setState(() {
          SnackBars().displaySnackBar("Comment Deleted!", () {}, context);
        });
        widget.updateCommentCount(false);
        deletingComment = false;
        return true;
      } else {
        SnackBars().displaySnackBar(
            "Something went wrong. We'll fix it soon!", () {}, context);
        deletingComment = false;
        return false;
      }
    } else {
      SnackBars().displaySnackBar(
          "Please wait for the delete process to complete.", () {}, context);
    }
    return false;
  }

  Future<bool> confirmDelete() async {
    bool deleteComment = await showDialog(
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
                      "Delete Comment?",
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
                          leftpadding: 20.0,
                          rightpadding: 20.0,
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
                          leftpadding: 20.0,
                          rightpadding: 20.0,
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
    return deleteComment;
  }

  void addMoreComments(index) {
    if (index + 1 == comments.length) {
      if (nextPageLink != "") {
        getCommentsWithPagination(widget.postId, nextPageLink)
            .then((Map apiResponse) {
          if (apiResponse["api_response"] == "Success") {
            if (apiResponse["comments"].length > 0) {
              setState(() {
                comments.addAll(apiResponse["comments"]);
                apiResponse["next_page_link"] == null
                    ? nextPageLink = ""
                    : nextPageLink = apiResponse["next_page_link"];
              });
            }
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    preparePageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Comments"),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 90.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // couple profile pictures
                  SizedBox(
                      width: 120.0,
                      height: 110.0,
                      child: Center(
                        child: Stack(
                          children: [
                            // couple partner 1
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
                                      backgroundImage: widget
                                                      .couple["partner_one"]
                                                  ["profile_picture"] !=
                                              null
                                          ? widget.couple["partner_one"]
                                                          ["profile_picture"]
                                                      ["image"] !=
                                                  ""
                                              ? NetworkImage(widget
                                                      .couple["partner_one"]
                                                  ["profile_picture"]["image"])
                                              : const NetworkImage(
                                                  "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png")
                                          : const NetworkImage(
                                              "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png"),
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
                                      backgroundImage: widget
                                                      .couple["partner_two"]
                                                  ["profile_picture"] !=
                                              null
                                          ? widget.couple["partner_two"]
                                                          ["profile_picture"]
                                                      ["image"] !=
                                                  ""
                                              ? NetworkImage(widget
                                                      .couple["partner_two"]
                                                  ["profile_picture"]["image"])
                                              : const NetworkImage(
                                                  "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png")
                                          : const NetworkImage(
                                              "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png"),
                                      radius: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  // couple usernames:
                  SizedBox(
                    width: 170.0,
                    child: Center(
                        child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: widget.couple["partner_one"]["username"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.black)),
                        const TextSpan(
                            text: " + ",
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.black)),
                        TextSpan(
                            text: widget.couple["partner_two"]["username"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.black)),
                      ]),
                    )),
                  ),

                  // Admirers:
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          // heart icon:
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: SvgPicture.asset(
                              'assets/svg/heart.svg',
                              width: 14.0,
                              colorFilter: const ColorFilter.mode(
                                  Colors.lightBlue, BlendMode.srcIn),
                            ),
                          )),
                          // admirers count:
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                widget.couple["admirers"].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300),
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

            // comment list:
            Expanded(
              flex: 6,
              child: pageLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Text(
                        "Fetching comments...",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    )
                  : comments.isNotEmpty
                      ? ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            addMoreComments(index);
                            return Dismissible(
                              crossAxisEndOffset: 2.0,
                              confirmDismiss: (dismissDirection) async {
                                bool isMyComment =
                                    await checkIfMyComment(comments[index]);
                                if (isMyComment) {
                                  bool delete = await confirmDelete();
                                  return delete;
                                }
                                return false;
                              },
                              key: GlobalKey(),
                              onDismissed: (direction) async {
                                bool deleted = await deleteComment(
                                    comments[index]["comment"]["id"]);
                                if (deleted) {
                                  setState(() {
                                    comments.removeAt(index);
                                  });
                                }
                              },
                              child: Comment(
                                commentIndex: index,
                                commentData: comments[index],
                              ),
                            );
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text(
                            "There are no comments",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
            ),

            // COMMENTS INPUT FIELD
            CommentInput(
              postCommentFunction: postAComment,
              postId: widget.postId,
              isReplying: false,
            ),
          ],
        ),
      ),
    );
  }
}
