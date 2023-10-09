import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authenticationapi.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final Rx<bool> signInStatus = Rx(true);
  final Rx<String> signInResponse = Rx("Signing in...");

  @override
  Widget build(BuildContext context) {
    signInUser();
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // loverfly logo
        SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              SizedBox(
                width: 40.0,
                height: MediaQuery.of(context).size.height,
                child: Transform(
                  child: Image.asset(
                    'assets/placeholders/logo.jpeg',
                    width: 60.0,
                  ),
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(6.0),
                ),
              ),
            ],
          ),
        ),
        Obx((() =>
            signInStatus.value ? const Text("") : Text(signInResponse.value)))
      ],
    ));
  }

  void signInUser() async {
    try {
      String? username;
      String? email;
      String? password;
      SharedPreferences cache = await SharedPreferences.getInstance();
      // if (!cache.containsKey("token")) {
      //   if (cache.containsKey("email") &&
      //       cache.containsKey("password") &&
      //       cache.containsKey("username")) {
      //     username = cache.getString("username");
      //     email = cache.getString("email");
      //     password = cache.getString("password");
      //   }

      // TODO: temp:
      username = "kai";
      email = "kai@gmail.com";
      password = "damonrecords";

      final Map token = await AuthenticationAPI().getAndCacheAPIToken(
          username: username, email: email, password: password);
      if (token.isNotEmpty &&
          !token.containsKey("error_info") &&
          cache.getString("token") != "") {
        Get.offAll(() => MainScreen(
              desiredPageIndex: 0,
            ));
      } else {
        signInStatus.value = false;
        signInResponse.value = token["error_info"];
      }
      // }
    } catch (e) {
      signInStatus.value = false;
      signInResponse.value =
          "Something went wrong on our end. We will fix it soon...";
    }
  }
}
