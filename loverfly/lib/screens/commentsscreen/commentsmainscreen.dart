import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/screens/commentsscreen/commentinput.dart';

import '../largerpreviewscreen/largerpreviewscreen.dart';
import 'api/commentsapi.dart';
import 'comment.dart';

class CommentScreen extends StatefulWidget {
  final int postId;
  final Map couple;

  const CommentScreen({
    Key? key,
    required this.postId,
    required this.couple,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final RxList comments = RxList([]);
  final RxBool preventRebuildProcess = RxBool(false);
  final RxBool pageLoading = RxBool(true);
  String nextPageLink = "";

  void preparePageData() async {
    if (!preventRebuildProcess.value) {
      var apiResponse = await getComments(widget.postId, "");
      if (apiResponse["api_response"] == "Success") {
        comments.addAll(apiResponse["comments"]);
        nextPageLink = apiResponse["next_page_link"];
      }
      pageLoading.value = false;
      preventRebuildProcess.value = true;
    }
  }

  void postAComment(postId, commentData) async {
    var apiResponse = await postComment(postId, commentData);
    apiResponse["api_response"] == "Success"
        ? comments
            .add({"comment_liked": false, "comment": apiResponse["comment"]})
        : null;
    setState(() {});
  }

  void removeDeletedComment(comment) {
    if (comments.isNotEmpty) {
      comments.remove(comment);
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
                                          imageurl: widget.couple["partner_one"]
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
                                      backgroundImage: widget
                                                      .couple["partner_one"]
                                                  ["profile_picture"] !=
                                              null
                                          ? NetworkImage(
                                              widget.couple["partner_one"]
                                                  ["profile_picture"])
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
                                          imageurl: widget.couple["partner_two"]
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
                                      backgroundImage: widget
                                                      .couple["partner_two"]
                                                  ["profile_picture"] !=
                                              null
                                          ? NetworkImage(
                                              widget.couple["partner_two"]
                                                  ["profile_picture"])
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
              child: Obx(
                () => pageLoading.value
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
                              if (index + 1 == comments.length) {
                                if (nextPageLink != "") {
                                  getCommentsWithPagination(
                                          widget.postId, nextPageLink)
                                      .then((Map apiResponse) {
                                    if (apiResponse["api_response"] ==
                                        "Success") {
                                      if (apiResponse["comments"].length > 0) {
                                        setState(() {
                                          comments
                                              .addAll(apiResponse["comments"]);
                                          apiResponse["next_page_link"] == null
                                              ? nextPageLink = ""
                                              : nextPageLink =
                                                  apiResponse["next_page_link"];
                                        });
                                      }
                                    }
                                  });
                                }
                              }
                              return Comment(
                                commentData: comments[index],
                                removeDeletedCommentFunction:
                                    removeDeletedComment,
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
            ),

            // COMMENTS INPUT FIELD
            CommentInput(
                postCommentFunction: postAComment, postId: widget.postId),
          ],
        ),
      ),
    );
  }
}
