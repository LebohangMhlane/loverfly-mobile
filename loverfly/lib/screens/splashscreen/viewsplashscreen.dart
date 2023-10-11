import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    runappchecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.0,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: Transform(
                child: Image.asset(
                  'assets/placeholders/logo.jpeg',
                  width: 50.0,
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
                style: TextStyle(fontSize: 17.0, color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void runappchecks() async {
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      SharedPreferences.getInstance().then((cache) {
        if (cache.containsKey("token") && cache.get("token") != "") {
          if (cache.containsKey("user_profile") &&
              cache.get("user_profile") != "") {
            Get.to(() => MainScreen(
                  desiredPageIndex: 0,
                ));
          }
        } else {
          Get.to(() => SignInScreen());
        }
      });
    });
  }
}
