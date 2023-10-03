import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/screens/signup/couplecreate/couplecreatescreen.dart';
import 'package:loverfly/screens/signup/signupapi.dart';
import 'package:loverfly/utils/pageutils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameCreateScreen extends StatelessWidget {
  UsernameCreateScreen({Key? key}) : super(key: key);

  final RxBool usernameTaken = RxBool(false);
  final RxBool profanityFound = RxBool(false);
  final TextEditingController usernameController = TextEditingController();

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

                // email address field:
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
                            CustomButton(
                                buttonlabel: "Continue",
                                buttoncolor: Colors.purple,
                                borderradius: 10.0,
                                leftmargin: 60.0,
                                rightmargin: 60.0,
                                onpressedfunction: () async {
                                  FocusScope.of(context).unfocus();
                                  String username = usernameController.text
                                      .trim()
                                      .replaceAll(RegExp(r'\s+'), '');
                                  createAccounts(username, context);
                                }),
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

  Future<bool> isProfanityFound(String username) async {
    try {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    try {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveToSharedPreferences(String username) async {
    try {
      SharedPreferences db = await SharedPreferences.getInstance();
      db.setString("username", username);
      return true;
    } catch (e) {
      return false;
    }
  }

  void createAccounts(String username, context) async {
    if (username != "") {
      // TODO: Complete username validations:
      profanityFound.value = await isProfanityFound(username);
      usernameTaken.value = await isUsernameTaken(username);
      // check all is valid and continue with sign up:
      if (!profanityFound.value && !usernameTaken.value) {
        await saveToSharedPreferences(username).then((saved) async {
          if (saved) {
            bool accountCreated = await createAccountAPI();
            accountCreated
                ? SnackBars().displaySnackBar("All done! Signing you up!", () {
                    Get.to(() => SignInScreen());
                  }, context)
                : SnackBars().displaySnackBar(
                    "Sign up failed. We're looking into it.", () {}, context);
          } else {
            SnackBars()
                .displaySnackBar("Something went wrong!", () {}, context);
          }
        });
      }
    }
  }
}
