import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/admire_button.dart';
import 'package:loverfly/features/couple_explorer/couple_explorer_api/coupleexplorerpageprovider.dart';
import 'package:loverfly/features/main_screen/main_screen_provider/main_screen_provider.dart';
import 'package:loverfly/features/main_screen/main_screen_widgets/page_load_error_widget.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/features/models/post.dart';
import 'package:loverfly/features/view_couple/view_couple_provider.dart';
import 'package:loverfly/utils/pageutils.dart';
import 'package:provider/provider.dart';
import '../../components/customappbar.dart';
import '../larger_image_view_screen/largerpreviewscreen.dart';

class ViewCouple extends StatefulWidget {

  final Couple couple;

  const ViewCouple({
    Key? key,
    required this.couple,
    })
    : super(key: key);

  @override
  State<ViewCouple> createState() => _ViewCoupleState();
}

class _ViewCoupleState extends State<ViewCouple> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Couple couple = widget.couple;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
    child: Scaffold(
    appBar: customAppBar(context, ""),
    body: ChangeNotifierProvider<ViewCoupleProvider>(
      create: (context) => ViewCoupleProvider(
        coupleId: int.parse(widget.couple.id)
      ),
      child: Consumer<ViewCoupleProvider>(
        builder: (context, coupleProvider, child) => coupleProvider.pageLoading ? 
        const Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.purple,
              strokeWidth: 1.0,
            ),
          ),
        ) : coupleProvider.errorOccured ? 
        const PageLoadErrorWidget(logOutFunction: logOut ) :
        SingleChildScrollView(
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
                                      top: 5.0, 
                                      bottom: 5.0
                                    ),
                                    child: Text(
                                      couple.relationshipStatus,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300
                                      )
                                    )
                                ),
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
                                                () =>  LargerPreviewScreen(image: couple.partnerOne!.profilePicture , postId: 000, isMyPost: false,),
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
                                                      couple.partnerOne!.profilePicture),
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
                                                () => LargerPreviewScreen(image: couple.partnerTwo!.profilePicture, postId: 000, isMyPost: false,),
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
                                                      couple.partnerTwo!.profilePicture),
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
                        couple.partnerOne!.username +
                            " & " +
                            couple.partnerTwo!.username,
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

                          // Admire button:
                          Consumer<MainPageProvider>(
                            builder: (context, mainPageProvider, child) => 
                            Consumer<CoupleExplorerProvider>(
                              builder: (context, coupleExplorerProvider, child) => 
                              AdmireButton(
                                coupleId: int.parse(couple.id), 
                                isAdmired: coupleProvider.isAdmired,
                                mainPageProvider: mainPageProvider,
                                coupleExplorerProvider: coupleExplorerProvider,
                              ),
                            ),
                          ),
        
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
                                        couple.startedDating,
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
                                        couple.nextAnniversary,
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
                                child: const Text(
                                    ""),
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
                                child:const Text(
                                    ""),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
        
                    // IMAGE LIST
                    SizedBox(
                    height: 450.0,
                    child: Container(
                        padding: const EdgeInsets.all(2.0),
                        height: 30.0,
                        child: GridView.builder(
                          itemCount: coupleProvider.couplePosts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            Post post =  coupleProvider.couplePosts[index];
                            return TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0)),
                              onPressed: () {
                                Get.to(
                                    () => LargerPreviewScreen(
                                      image: post.postImage, 
                                      postId: post.id, 
                                      isMyPost: false,
                                    ),
                                    opaque: false);
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            post.postImage),
                                        fit: BoxFit.cover),
                                  )),
                            );
                          },
                        ),
                      ),
                    ),
                    // ROW 6
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
