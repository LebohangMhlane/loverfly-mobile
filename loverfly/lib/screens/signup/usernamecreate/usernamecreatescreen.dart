import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/api/authentication/authenticationapi.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import 'package:loverfly/screens/signup/signupapi.dart';
import 'package:loverfly/utils/pageutils.dart';

class UsernameCreateScreen extends StatelessWidget {
  UsernameCreateScreen({Key? key}) : super(key: key);

  final RxBool usernameTaken = RxBool(false);
  final RxBool profanityFound = RxBool(false);
  final TextEditingController usernameController = TextEditingController();
  final RxBool completingSignUp = RxBool(false);

  // cache:
  final cache = GetStorage();

  // TODO: Complete username validations:

  // TODO: Isolate the save to shared preferences function and make it reuseable:

  Future<bool> isProfanityFound(String username) async {
    try {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveToCache(String username) async {
    try {
      cache.write("username", username);
      return true;
    } catch (e) {
      return false;
    }
  }

  void getTokenAndNavigate(context) async {
    try {
      if (!cache.hasData("token") &&
          cache.hasData("username") &&
          cache.hasData("password")) {
        String? username = cache.read("username");
        String? password = cache.read("password");
        Map tokenResponse = await AuthenticationAPI()
            .getAndCacheAPIToken(username: username, password: password);
        if (tokenResponse.containsKey("token") &&
            tokenResponse["token"] != "") {
          Get.offAll(() => MainScreen(
                desiredPageIndex: 0,
              ));
        }
      } else {
        SnackBars().displaySnackBar(
            "Something went wrong. We will fix it soon!", () => null, context);
      }
    } catch (e) {
      return;
    }
  }

  void processUsername(String username, context) async {
    Map accountCreated = {};
    if (username != "") {
      profanityFound.value = await isProfanityFound(username);
      if (!profanityFound.value && !usernameTaken.value) {
        bool savedToCache = await saveToCache(username);
        if (savedToCache) {
          accountCreated = await signUp();
          accountCreated["status"]
              ? SnackBars().displaySnackBar("All done. Signing you in!", () {
                  getTokenAndNavigate(context);
                }, context)
              : SnackBars()
                  .displaySnackBar(accountCreated["error"], () {}, context);
          completingSignUp.value = false;
        } else {
          SnackBars().displaySnackBar(accountCreated["error"], () {}, context);
          completingSignUp.value = false;
        }
      } else {
        completingSignUp.value = false;
      }
    } else {
      completingSignUp.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // logo
                Padding(
                    padding: const EdgeInsets.only(top: 100.0, bottom: 30.0),
                    child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Container(
                            width: 20.0,
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
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: const Text(
                              'LoverFly',
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.purple),
                            ),
                          ),
                        ]))),

                const SizedBox(
                  height: 10.0,
                ),

                // username field:
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, bottom: 10.0),
                                  child: Text(
                                    "Pick an entertaining username!",
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                )),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5,
                                        color: const Color.fromRGBO(
                                            156, 39, 176, 1)),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                  ],
                                  style: const TextStyle(fontSize: 13.0),
                                  onTap: () {},
                                  onChanged: (value) {},
                                  controller: usernameController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "What does bae call you?",
                                      contentPadding: EdgeInsets.only(
                                          left: 10.0, right: 10.0)),
                                )),
                            const SizedBox(
                              height: 8.0,
                            ),
                            usernameTaken.isTrue
                                ? SizedBox(
                                    height: 20.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "That username is already taken!",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            profanityFound.isTrue
                                ? SizedBox(
                                    height: 20.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Usernames like that aren't allowed.",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 15.0,
                            ),

                            // TODO: Ensure white space regex is applied on all password and email fields:

                            Obx(
                              () => CustomButton(
                                  buttonlabel: completingSignUp.isTrue
                                      ? "..."
                                      : "Continue",
                                  buttoncolor: Colors.purple,
                                  borderradius: 10.0,
                                  leftmargin: 60.0,
                                  rightmargin: 60.0,
                                  onpressedfunction: () async {
                                    if (completingSignUp.isFalse) {
                                      completingSignUp.value = true;
                                      FocusScope.of(context).unfocus();
                                      String username = usernameController.text
                                          .trim()
                                          .replaceAll(RegExp(r'\s+'), '');
                                      processUsername(username, context);
                                    }
                                  }),
                            ),
                            const SizedBox(
                              height: 50.0,
                            )
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
