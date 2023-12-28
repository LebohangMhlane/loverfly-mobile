import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/couplescreen/viewcouple.dart';

class PageUtils {
  void navigateToCoupleScreen(coupledata, rebuildCoupleExplorer) {
    Get.to(() => CoupleProfileScreen(
          coupleId: coupledata["id"],
          isAdmired: coupledata["isAdmired"],
          rebuildPageFunction: rebuildCoupleExplorer,
        ));
  }
}

class SnackBars {
  void displaySnackBar(String message, Function() function, context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          backgroundColor: Colors.purple,
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
          duration: const Duration(milliseconds: 2000),
          dismissDirection: DismissDirection.horizontal,
        ))
        .closed
        .then((value) {
      function();
    });
  }
}
