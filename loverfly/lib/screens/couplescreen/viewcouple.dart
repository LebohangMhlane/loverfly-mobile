import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/userinteractions/admire/admireapi.dart';
import 'package:loverfly/utils/pageutils.dart';
import '../../components/customappbar.dart';
import '../../components/custombutton.dart';
import '../../utils/utils.dart';
import '../largerpreviewscreen/largerpreviewscreen.dart';
import 'api/couplescreenapi.dart';

class CoupleProfileScreen extends StatefulWidget {
  final Map couple;
  final RxBool isAdmired;
  final Function rebuildPageFunction;

  const CoupleProfileScreen(
      {Key? key,
      required this.couple,
      required this.isAdmired,
      required this.rebuildPageFunction})
      : super(key: key);

  @override
  State<CoupleProfileScreen> createState() => _CoupleProfileScreenState();
}

class _CoupleProfileScreenState extends State<CoupleProfileScreen> {
  final RxMap coupledata = RxMap({});

  final RxMap relationshipstartdate = RxMap({});

  final RxMap nextanniversarydate = RxMap({});

  final RxString anniversarycount = RxString("0");

  final RxInt numberOfAdmirers = RxInt(0);

  final RxInt numOfAdmiredCouples = RxInt(0);

  final RxList posts = RxList([]);

  final RxBool pageLoaded = RxBool(false);

  String partnerOneProfilePicture = "";

  String partnerTwoProfilePicture = "";

  @override
  void initState() {
    preparepagedata();
    super.initState();
  }

  void preparepagedata() async {
    if (!pageLoaded.value) {
      // convert date values:
      relationshipstartdate.value =
          DateFunctions().convertdate(widget.couple["started_dating"]);
      nextanniversarydate.value =
          DateFunctions().convertdate(widget.couple["next_anniversary"]);

      // set counts:
      anniversarycount.value = DateFunctions()
          .determineanniversarycount(widget.couple["anniversaries"]);
      numberOfAdmirers.value = widget.couple["admirers"];

      // get couple posts:
      await getCouplePosts(widget.couple["id"]).then((apiResponse) {
        if (apiResponse["api_response"] != "failed") {
          posts.value = apiResponse["couple_posts"];
        }
        pageLoaded.value = true;
      });

      // set profile pictures:
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
      setState(() {});
    }
  }

  void admireCouple(context) async {
    try {
      Map response = await admire(widget.couple["id"], widget.isAdmired);
      if (response.containsKey("error_info")) {
        SnackBars().displaySnackBar(
            "Something went wrong. We will fix it soon!", () => null, context);
      } else {
        widget.isAdmired.value = response["admired"];
        if (widget.isAdmired.value == false) {
          if (numberOfAdmirers.value != 0) {
            numberOfAdmirers.value--;
          }
        } else {
          numberOfAdmirers.value++;
        }
      }
    } catch (e) {
      SnackBars().displaySnackBar(
          "Something went wrong. We will fix it soon!", () => null, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          widget.rebuildPageFunction(true, context);
          return true;
        },
        child: Scaffold(
            appBar: customAppBar(context, ""),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // row 1
                        Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              // relationship stage
                              Container(
                                width: 140.0,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Image.asset(
                                        'assets/placeholders/logo.jpeg',
                                        width: 30.0,
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Text(
                                            widget
                                                .couple["relationship_status"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300))),
                                  ],
                                ),
                              ),

                              // profile pictures
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                    width: 110.0,
                                    height: 110.0,
                                    child: Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(40.0),
                                                bottomLeft:
                                                    Radius.circular(40.0))),
                                        padding: const EdgeInsets.only(
                                            left: 65.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        child: Stack(
                                          children: [
                                            // couple partner 1 profile picture:
                                            Positioned(
                                              left: 50.0,
                                              child: GestureDetector(
                                                onTap: () => Get.to(
                                                    () => LargerPreviewScreen(
                                                          imageurl:
                                                              partnerOneProfilePicture,
                                                          myImage: false,
                                                          postId: 000,
                                                        ),
                                                    opaque: false),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100.0)),
                                                        color: Colors.purple),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    width: 70.0,
                                                    height: 70.0,
                                                    child: CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          partnerOneProfilePicture),
                                                      radius: 25.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // couple partner 2 profile picture:
                                            Positioned(
                                              top: 25.0,
                                              child: GestureDetector(
                                                onTap: () => Get.to(
                                                    () => LargerPreviewScreen(
                                                          imageurl:
                                                              partnerTwoProfilePicture,
                                                          myImage: false,
                                                          postId: 000,
                                                        ),
                                                    opaque: false),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100.0)),
                                                        color: Colors.purple),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    width: 65.0,
                                                    height: 65.0,
                                                    child: CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          partnerTwoProfilePicture),
                                                      radius: 25.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        // ROW 1

                        // row 2
                        Container(
                          alignment: Alignment.centerRight,
                          width: 240.0,
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            bottom: 15.0,
                          ),
                          child: Text(
                            widget.couple["partner_one"]["username"] +
                                " & " +
                                widget.couple["partner_two"]["username"],
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        // ROW 2

                        // row 3
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0))),
                          margin: const EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              // Admire couple button:
                              Expanded(
                                  child: Center(
                                      child: CustomButton(
                                          elevation: 0.0,
                                          splashcolor: Colors.blue,
                                          buttoncolor: Colors.white,
                                          buttonlabel: 'Admire',
                                          fontWeight: FontWeight.bold,
                                          textcolor: Colors.black,
                                          icon: Obx(
                                            () => Container(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: widget.isAdmired.value
                                                  ?
                                                  // Admire heart icon
                                                  Transform(
                                                      child: Image.asset(
                                                        'assets/placeholders/logo.jpeg',
                                                        width: 17.0,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      transform:
                                                          Matrix4.rotationZ(
                                                              6.0),
                                                    )
                                                  :
                                                  // not Admired heart icon:
                                                  SvgPicture.asset(
                                                      'assets/svg/heart.svg',
                                                      alignment:
                                                          Alignment.center,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(Colors.grey,
                                                              BlendMode.srcIn),
                                                      width: 20.0,
                                                    ),
                                            ),
                                          ),
                                          onpressedfunction: () async {
                                            admireCouple(context);
                                          }))),

                              // relationship advice request:
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Icon(
                                              Icons.mail,
                                              color: Colors.deepPurple,
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ROW 3

                        const Divider(
                          thickness: 1.0,
                          indent: 60.0,
                          endIndent: 60.0,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Together Since",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.purple),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Next Anniversary",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.purple),
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 5.0,
                        ),

                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(1.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            relationshipstartdate["normalized"]
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            nextanniversarydate["normalized"]
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(
                          thickness: 1.0,
                          indent: 60.0,
                          endIndent: 60.0,
                        ),

                        // ROW 6
                        Container(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(
                            children: [
                              // Admirers:
                              Expanded(
                                child: Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 6.0, bottom: 6.0),
                                    child: const Text(
                                      'Admired Couples',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 12.0),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      'assets/svg/heart.svg',
                                      width: 20.0,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.deepPurple, BlendMode.srcIn),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Obx(() => Text(
                                        numOfAdmiredCouples.value.toString())),
                                  )
                                ]),
                              ),

                              // Admirers:
                              Expanded(
                                child: Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 6.0, bottom: 6.0),
                                    child: const Text(
                                      'Admirers',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 12.0),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      'assets/svg/heart.svg',
                                      width: 20.0,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.blue, BlendMode.srcIn),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Obx(() => Text(
                                        numberOfAdmirers.value.toString())),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),

                        // IMAGE LIST
                        SizedBox(
                            height: 450.0,
                            child: Obx(
                              () => Container(
                                padding: const EdgeInsets.all(2.0),
                                height: 30.0,
                                child: GridView.builder(
                                  itemCount: posts.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0)),
                                      onPressed: () {
                                        Get.to(
                                            () => LargerPreviewScreen(
                                                  imageurl: posts[index]
                                                      ["post_image"],
                                                  myImage: false,
                                                  postId: 000,
                                                ),
                                            opaque: false);
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    posts[index]["post_image"]),
                                                fit: BoxFit.cover),
                                          )),
                                    );
                                  },
                                ),
                              ),
                            )),
                        // ROW 6
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
