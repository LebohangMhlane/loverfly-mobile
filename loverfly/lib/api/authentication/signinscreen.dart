import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import 'authenticationapi.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final Rx<bool> signInStatus = Rx(true);
  final Rx<String> signInResponse = Rx("Signing in...");

  @override
  Widget build(BuildContext context) {
    signinuser(
        email: "kai@gmail.com", password: "damonrecords", username: "kai");

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
                width: 20.0,
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

              // loverfly text
              // Container(
              //   padding: const EdgeInsets.only(left: 2.0),
              //   height: MediaQuery.of(context).size.height,
              //   color: Colors.transparent,
              //   alignment: Alignment.center,
              //   child: const Text(
              //     'LoverFly ',
              //     style: TextStyle(fontSize: 15.0, color: Colors.purple),
              //   ),
              // ),
            ],
          ),
        ),

        // indicate the status of the sign in process
        // Obx((() => signInStatus.value
        //     ? Text(signInResponse.value)
        //     : Text(signInResponse.value)))

        Obx((() =>
            signInStatus.value ? const Text("") : Text(signInResponse.value)))
      ],
    ));
  }

  // =============================================================================
  // sign the user in and save their data to local storage to keep them signed in:
  // =============================================================================

  void signinuser({email, password, username}) async {
    try {
      var firebaseSignInSuccessful = await signIntoFirebase(email, password);

      // if we signed in successfully to firebase we can now get the api token:
      if (firebaseSignInSuccessful) {
        final Map tokenMap = await AuthenticationAPI().getAndCacheAPIToken(
            username: username, email: email, password: password);
        if (tokenMap.isNotEmpty && !tokenMap.containsKey("error_info")) {
          Get.offAll(() => MainScreen());
        } else {
          signInStatus.value = false;
          signInResponse.value = tokenMap["error_info"];
        }
      } else {
        signInResponse.value = "Wrong email or password";
      }
    } catch (e) {
      signInStatus.value = false;
      signInResponse.value =
          "Something went wrong on our end. We will fix it soon...";
    }
  }

  Future<bool> signIntoFirebase(email, password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
