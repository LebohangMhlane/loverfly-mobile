import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/screens/commentsscreen/commentinput.dart';

import '../largerpreviewscreen/largerpreviewscreen.dart';
import 'api/commentsapi.dart';
import 'comment.dart';

class CommentScreen extends StatelessWidget {
  final int postId;
  final Map couple;

  CommentScreen({
    Key? key,
    required this.postId,
    required this.couple,
  }) : super(key: key);

  final RxList comments = RxList([]);
  final RxBool preventRebuildProcess = RxBool(false);
  final RxBool pageLoading = RxBool(true);

  void preparePageData() async {
    if (!preventRebuildProcess.value) {
      var apiResponse = await getComments(postId);
      apiResponse["api_response"] == "Success"
          ? comments.addAll(apiResponse["comments"])
          : null;
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
  }

  void removeDeletedComment(comment) {
    if (comments.isNotEmpty) {
      comments.remove(comment);
    }
  }

  @override
  Widget build(BuildContext context) {
    preparePageData();

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
                      )),

                  SizedBox(
                    width: 199.0,
                    child: Center(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
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

            // COMMENT VIEWER
            Expanded(
              flex: 6,
              child: Obx(
                () => pageLoading.value
                    ? const Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text(
                          "Fetching comments",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      )
                    : comments.isNotEmpty
                        ? ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
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
            CommentInput(postCommentFunction: postAComment, postId: postId),
          ],
        ),
      ),
    );
  }
}
