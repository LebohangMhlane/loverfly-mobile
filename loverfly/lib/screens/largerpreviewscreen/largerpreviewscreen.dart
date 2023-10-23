import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/custombutton.dart';

import '../myprofilescreen/api/myprofilescreen.dart';

class LargerPreviewScreen extends StatelessWidget {
  LargerPreviewScreen(
      {Key? key,
      required this.imageurl,
      required this.myImage,
      required this.resetPage,
      required this.postId})
      : super(key: key);

  final String imageurl;
  final RxString imageurlstring = RxString("");
  final bool myImage;
  final RxBool showConfirmationOverlay = RxBool(false);
  final int postId;
  final Function resetPage;

  @override
  Widget build(BuildContext context) {
    // trigger the rebuild or the picture won't update when changed:
    imageurlstring.value = imageurl;
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 0, 0, 0),
      body: Column(
        children: [
          const SizedBox(
            height: 85.0,
          ),

          // image previewer:
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              child: Column(children: [
                // image options only shown if the image viewed belongs to this user or user couple:
                myImage
                    ? Expanded(
                        child: Container(
                          color: Colors.black,
                          child: Row(children: [
                            Expanded(
                                child: SizedBox(
                                    child: CustomButton(
                              buttonlabel: "",
                              buttoncolor:
                                  const Color.fromARGB(40, 255, 255, 255),
                              textcolor:
                                  const Color.fromARGB(234, 255, 255, 255),
                              splashcolor:
                                  const Color.fromARGB(139, 248, 246, 248),
                              onpressedfunction: () {
                                // showConfirmationOverlay.value = showConfirmationOverlay.value == true ? false : true;
                              },
                            ))),
                            Expanded(
                                child: SizedBox(
                                    child: CustomButton(
                              buttonlabel: "Delete Memory",
                              buttoncolor:
                                  const Color.fromARGB(40, 255, 255, 255),
                              textcolor:
                                  const Color.fromARGB(234, 255, 255, 255),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              splashcolor:
                                  const Color.fromARGB(139, 248, 246, 248),
                              onpressedfunction: () {
                                showConfirmationOverlay.value =
                                    showConfirmationOverlay.value == true
                                        ? false
                                        : true;
                              },
                            )))
                          ]),
                        ),
                      )
                    : const SizedBox(),

                // image holder:
                Expanded(
                  flex: 11,
                  child: Obx(
                    () => InteractiveViewer(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(1.0),
                        decoration: const BoxDecoration(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // image:
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: imageurlstring.value != ""
                                  ? Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        fit: BoxFit.contain,
                                        alignment: FractionalOffset.center,
                                        image:
                                            NetworkImage(imageurlstring.value),
                                      )),
                                    )
                                  : const Center(
                                      child: Text(
                                        "No image to display",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),

                            showConfirmationOverlay.value
                                ?

                                // confirmation overlay:
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 420.0,
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 30.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 20.0,
                                              color: Colors.transparent,
                                              child: Transform(
                                                child: Image.asset(
                                                  'assets/placeholders/logo.jpeg',
                                                  width: 30.0,
                                                ),
                                                alignment: Alignment.center,
                                                transform:
                                                    Matrix4.rotationZ(6.0),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'LoverFly',
                                                style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.purple),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 24.0,
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                          child: Text(
                                            "Notice: Deleting Memories",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.0,
                                              left: 25.0,
                                              right: 25.0,
                                              bottom: 8.0),
                                          child: Text(
                                            "Memories you set to delete will be permanently deleted after 30 days. This means, that if you delete a memory on accident or wish to retrieve a memory you once deleted, it will be possible only if the memory is retrieved within 30 days. You can view and retrieve your deleted memories in 'settings' > 'Activity' > 'Deleted Memories'. Deleted memories will not appear on your timeline or couple image list to be viewed by your followers",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: Colors.purple,
                                                height: 1.3),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomButton(
                                              buttonlabel: "Cancel",
                                              buttoncolor: Colors.purple,
                                              rightmargin: 20.0,
                                              borderradius: 10.0,
                                              leftpadding: 20.0,
                                              rightpadding: 20.0,
                                              onpressedfunction: () {
                                                showConfirmationOverlay.value =
                                                    false;
                                              },
                                            ),
                                            CustomButton(
                                              buttonlabel: "Delete",
                                              buttoncolor: Colors.purple,
                                              borderradius: 10.0,
                                              leftpadding: 25.0,
                                              rightpadding: 25.0,
                                              onpressedfunction: () async {
                                                deletePost(postId)
                                                    .then((responseMap) {
                                                  if (responseMap[
                                                      "post_deleted"]) {
                                                    showConfirmationOverlay
                                                        .value = false;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                          backgroundColor:
                                                              Colors.purple,
                                                          content: Text(
                                                            'Memory Deleted!',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  2000),
                                                        ))
                                                        .closed
                                                        .then((value) {
                                                      resetPage();
                                                      Get.back();
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ]),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),

          const SizedBox(
            height: 85.0,
          ),
        ],
      ),
    );
  }
}
