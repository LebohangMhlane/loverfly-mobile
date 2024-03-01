

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/features/couple_explorer/couple_explorer_api/coupleexplorerpageprovider.dart';
import 'package:loverfly/features/main_screen/main_screen_provider/main_screen_provider.dart';
import 'package:loverfly/user_interactions/admire/admireapi.dart';

class AdmireButton extends StatefulWidget {

  final bool isAdmired;
  final int coupleId;
  final MainPageProvider mainPageProvider;
  final CoupleExplorerProvider coupleExplorerProvider;

  const AdmireButton({
    Key? key,
    required this.isAdmired,
    required this.coupleId,
    required this.mainPageProvider,
    required this.coupleExplorerProvider,
  }) : super(key: key);

  @override
  State<AdmireButton> createState() => _AdmireButtonState();
}

class _AdmireButtonState extends State<AdmireButton> {

  late bool isAdmired;
  late int coupleId;
  late MainPageProvider mainPageProvider;
  CoupleExplorerProvider coupleExplorerProvider = CoupleExplorerProvider();

  @override
  void initState() {
    super.initState();
    isAdmired = widget.isAdmired;
    coupleId = widget.coupleId;
    mainPageProvider = widget.mainPageProvider;
    coupleExplorerProvider = widget.coupleExplorerProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CustomButton(
          elevation: 0.0,
          splashcolor: Colors.blue,
          buttoncolor: Colors.white,
          buttonlabel: 'Admire',
          fontWeight: FontWeight.bold,
          textcolor: Colors.black,
          icon: Container(
            padding: const EdgeInsets.only(
              left: 4.0
            ),
            child: isAdmired ?
              // admired heart icon:
              Transform(
                child: Image.asset(
                  'assets/placeholders/logo.jpeg',
                  width: 25.0,
                ),
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(6.0),
              )
              :
              // not Admired heart icon:
              SvgPicture.asset(
                'assets/svg/heart.svg',
                alignment: Alignment.center,
                colorFilter: const ColorFilter.mode(
                  Colors.grey, BlendMode.srcIn
                ),
                width: 20.0,
              ),
          ),
          onpressedfunction: () async {
            Map response = await admire(coupleId, isAdmired);
            if(response["api_response"] == "Success"){
              setState(() {
                isAdmired = response["admired"];
              });
              refreshMainPagePostList();
              refreshCoupleExplorerPage();
            }
          }
        )
      ),
    );
  }

  // TODO: There must be a more optimized way to do this:
  // based on the changes to couple amdire two things must happen:
  // 1: The main page must remove the profile that has been unAdmired.
  // 2: The coupleExplorer page must update the state of the couple card 
  // for this couple to have a button that is unAdmired or admired based on
  // the users selection.

  void refreshMainPagePostList(){
    mainPageProvider.refreshPosts();
  }

  void refreshCoupleExplorerPage(){
    coupleExplorerProvider.refreshCoupleExplorerPage();
  }

}