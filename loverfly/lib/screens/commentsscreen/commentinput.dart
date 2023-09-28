import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custombutton.dart';
import '../../utils/pageutils.dart';

class CommentInput extends StatelessWidget {
  final int postId;
  final Function postCommentFunction;
  final TextEditingController commentInputController = TextEditingController();
  final RxBool postingComment = RxBool(false);

  CommentInput(
      {Key? key, required this.postCommentFunction, required this.postId})
      : super(key: key);

  void createComment(context) async {
    FocusScope.of(context).unfocus();
    if (!postingComment.value && commentInputController.text.isNotEmpty) {
      postingComment.value = true;
      var commentData = {
        "post_id": postId,
        "comment": commentInputController.text,
      };
      await postCommentFunction(postId, commentData);
      postingComment.value = false;
      SnackBars().displaySnackBar("Comment Created", () {}, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey)]),
              margin: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 10.0),
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                  controller: commentInputController,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type your comment here:"),
                ),
              ),
            ),
          ),
          Obx(
            () => Expanded(
                child: !postingComment.value
                    ? CustomButton(
                        rightmargin: 10.0,
                        borderradius: 10.0,
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 20.0,
                        ),
                        buttonlabel: "",
                        buttoncolor: Colors.purple,
                        onpressedfunction: () async {
                          createComment(context);
                        },
                      )
                    : const Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.purple,
                            strokeWidth: 2.0,
                          ),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
