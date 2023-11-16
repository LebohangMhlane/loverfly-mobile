import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../components/custombutton.dart';
import '../../utils/pageutils.dart';
import '../mainscreen/mainscreen.dart';
import 'api/createapostscreenapi.dart';

class CreateAPostScreen extends StatefulWidget {
  final Function resetPageFunction;
  const CreateAPostScreen({Key? key, required this.resetPageFunction})
      : super(key: key);

  @override
  _CreateAPostScreenState createState() => _CreateAPostScreenState();
}

class _CreateAPostScreenState extends State<CreateAPostScreen> {
  TextEditingController captioncontroller = TextEditingController();

  XFile? selectedimage;
  ImagePicker imagepicker = ImagePicker();

  var imagedownloadurl = '';
  var userProfile = Rx<Map>({});
  var couple = Rx<Map>({});
  Map partnerOne = {};
  bool isPartnerOne = false;
  RxBool savingpost = RxBool(false);
  RxBool error = RxBool(false);
  String dayOfWeek = "";
  String date = "";

  @override
  void initState() {
    try {} catch (e) {
      setMainPartner();
      formatDates();
      return;
    }
    super.initState();
  }

  void setMainPartner() {
    var cache = GetStorage();
    userProfile.value = jsonDecode(cache.read('user_profile')!);
    couple.value = jsonDecode(cache.read('user_couple')!);
    couple.value["partner_one"]["username"] == userProfile.value["username"]
        ? partnerOne = userProfile.value
        : partnerOne = couple.value["partner_one"];
  }

  void createMemory() async {
    try {
      // prevent button spamming:
      if (savingpost.value == true) {
        return;
      }
      savingpost.value = true;
      File imageFile = File(selectedimage!.path);
      var caption = captioncontroller.value.text != ''
          ? captioncontroller.value.text
          : partnerOne["username"] + ' + ' + userProfile.value['username'];
      var postUploaded =
          await uploadPostToServerDatabase(context, caption, imageFile);
      var coupleDataUpdated = await updateCoupleData();
      validateAndNotifyUser(context, coupleDataUpdated, postUploaded);
    } catch (e) {
      SnackBars().displaySnackBar("Something went wrong.", () => null, context);
    }
  }

  Future<bool> uploadPostToServerDatabase(context, caption, imageFile) async {
    try {
      Map apiResponse = await createAPost(caption, imageFile);
      if (apiResponse.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.purple,
          content: Text(
            'An error has occured. Please try again.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(milliseconds: 3000),
        ));
        savingpost.value = false;
        return false;
      } else {
        return true;
      }
    } catch (error) {
      handleError(error);
      return false;
    }
  }

  Future<bool> updateCoupleData() async {
    try {
      var cache = GetStorage();
      var couple = cache.read("user_couple");
      Map jsonCouple = jsonDecode(couple!);
      jsonCouple["has_posts"] = true;
      cache.write("user_couple", jsonEncode(jsonCouple));
      return true;
    } catch (error) {
      handleError(error);
      return false;
    }
  }

  void validateAndNotifyUser(
      context, coupleDataUpdated, postUploadedToServerDatabase) {
    if (coupleDataUpdated && postUploadedToServerDatabase) {
      SnackBars().displaySnackBar("Memory Shared Successfully", () {}, context);
      savingpost.value = false;
      Get.offAll(() => MainScreen(
            desiredPageIndex: 0,
          ));
    }
  }

  void handleError(error) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.purple,
      content: Text(
        'An error has occured. Please try again.',
        textAlign: TextAlign.center,
      ),
      duration: Duration(milliseconds: 3000),
    ));
    savingpost.value = false;
  }

  formatDates() {
    dayOfWeek = DateFormat('EEEE').format(DateTime.now());
    date = DateFormat('dd/MM/yy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() {
        Get.off(() => MainScreen(
              desiredPageIndex: 0,
            ));
        return true;
      }),
      child: Builder(
          builder: (context) => Scaffold(
              appBar: AppBar(
                toolbarHeight: 35.0,
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 15.0,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      child: Transform(
                        child: Image.asset(
                          'assets/placeholders/logo.jpeg',
                          width: 20.0,
                        ),
                        alignment: Alignment.center,
                        transform: Matrix4.rotationZ(6.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 2.0),
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: const Text(
                        'LoverFly',
                        style: TextStyle(fontSize: 15.0, color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // TITLE
                    Container(
                      color: Colors.purple,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10.0),
                              child: const Text(
                                'Share a memory',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: CustomButton(
                                buttoncolor: Colors.purple,
                                onpressedfunction: () {
                                  Get.back();
                                },
                                buttonlabel: '',
                                customchild: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // IMAGE
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(2.0),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // IMAGE
                          SizedBox(
                            height: selectedimage == null ? 400.0 : null,
                            child: selectedimage == null
                                ? Center(
                                    child: SizedBox(
                                      width: 30.0,
                                      height: 30.0,
                                      child: Image.asset(
                                          'assets/placeholders/logo.jpeg'),
                                    ),
                                  )
                                : AspectRatio(
                                    aspectRatio: max(0, 900) / max(0, 1070),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        fit: BoxFit.cover,
                                        alignment: FractionalOffset.center,
                                        image: Image.file(
                                                File(selectedimage!.path))
                                            .image,
                                      )),
                                    ),
                                  ),
                          ),

                          // CAPTION
                          Opacity(
                            opacity: 0.6,
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black,
                              width: MediaQuery.of(context).size.width,
                              height: 60.0,
                              margin: const EdgeInsets.only(bottom: 40.0),
                              child: Text(captioncontroller.text.toString(),
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ),

                          // TIME DATE STAMP AND COUPLE VERIFICATION
                          Container(
                              alignment: Alignment.topRight,
                              padding: const EdgeInsets.only(
                                  bottom: 12.0, right: 15.0, left: 15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dayOfWeek + ' - ' + date,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    ),
                                  ),
                                  const Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: Colors.purple,
                                      shadows: <Shadow>[
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),

                    // UPLOAD FUNCTIONS
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.black,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      // grab the image from the camera:
                                      var imageFromCamera =
                                          await imagepicker.pickImage(
                                              source: ImageSource.camera);
                                      setState(() {
                                        selectedimage = imageFromCamera;
                                      });
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      //  grab the image from the gallery
                                      var imageFromGallery =
                                          await imagepicker.pickImage(
                                              source: ImageSource.gallery);
                                      setState(() {
                                        selectedimage = imageFromGallery;
                                      });
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 30.0,
                    ),

                    // CAPTION CREATION
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: const Text('Edit Caption',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 30.0, right: 10.0),
                            child: TextField(
                              maxLength: 41,
                              cursorHeight: 20.0,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'This will be you and your partners usernames if left empty',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11.0,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.deepPurple,
                              ),
                              cursorColor: Colors.black,
                              controller: captioncontroller,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    // SAVE THE COUPLES POST
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.deepPurpleAccent,
                            child: TextButton(
                              onPressed: () async {
                                try {
                                  // ensure there is an image to save:
                                  if (selectedimage != null) {
                                    createMemory();
                                  }
                                } catch (error) {
                                  handleError(error);
                                  return;
                                }
                              },
                              child: Obx(
                                () => Container(
                                  padding: const EdgeInsets.all(20.0),
                                  alignment: Alignment.center,
                                  child: !savingpost.value
                                      ? const Text(
                                          'Share',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text('Saving Post',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10.0),
                                                width: 10.0,
                                                height: 10.0,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                ),
                              ),
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.white.withOpacity(.1))),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ))),
    );
  }
}
