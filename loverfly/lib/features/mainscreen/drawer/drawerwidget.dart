

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/features/coupleexplorerscreen/coupleexplorerpage.dart';
import 'package:loverfly/utils/pageutils.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
    required this.closeDrawerFunction,
    required this.logOutFunction,
  }) : super(key: key);

  final Function closeDrawerFunction;
  final Function logOutFunction;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 250.0,
      child: ListView(
        children: [

          const SizedBox(
            height: 100.0,
          ),
      
          SizedBox(
            height: 60.0,
            child: CustomButton(
              buttonlabel: 'Couple Explorer',
              textfontsize: 12.0,
              buttoncolor: Colors.purple,
              onpressedfunction: () async {
                await Future.delayed(const Duration(milliseconds:250));
                closeDrawerFunction();
                Get.to(()=>CoupleExplorerScreen());
              },
            ),
          ),

          Container(
            height: 60.0,
            color: Colors.yellow,
            child: CustomButton(
              buttonlabel: "Log Out",
              textfontsize: 12.0,
              onpressedfunction: () {
                logOutFunction();
              },
            ),
          )

        ],
      ),
        
    );  
  }
}