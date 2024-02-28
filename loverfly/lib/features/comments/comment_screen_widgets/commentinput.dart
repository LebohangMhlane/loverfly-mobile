import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/utils/pageutils.dart';

class CommentInput extends StatefulWidget {
  final int postId;
  final Function postCommentFunction;
  final bool isReplying;

  const CommentInput(
      {Key? key,
      required this.postCommentFunction,
      required this.postId,
      required this.isReplying})
      : super(key: key);

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController commentInputController = TextEditingController();
  final RxBool postingComment = RxBool(false);
  final RxString savedCommentValue = RxString("");

  void createComment(context, comment) async {
    FocusScope.of(context).unfocus();
    if (!postingComment.value && comment != "") {
      postingComment.value = true;
      var commentData = {
        "comment_id": widget.postId.toString(),
        "comment": comment,
      };
      await widget.postCommentFunction(widget.postId, commentData);
      setState(() {
        commentInputController.clear();
        postingComment.value = false;
      });
      SnackBars().displaySnackBar("Comment Created", () {}, context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    commentInputController.dispose();
    super.dispose();
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
                child: TextField(
                  onChanged: (value) {
                    if (commentInputController.text.length >= 50) {
                      setState(() {
                        value = value.substring(0, value.length - 1);
                        commentInputController.text = value;
                      });
                    }
                  },
                  controller: commentInputController,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: !widget.isReplying
                          ? "Type your comment here:"
                          : "Type your reply here:"),
                ),
              ),
            ),
          ),
          Expanded(
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
                        createComment(context, commentInputController.text);
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
        ],
      ),
    );
  }
}
