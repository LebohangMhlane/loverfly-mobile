import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/custombutton.dart';

class UsernameCreateScreen extends StatelessWidget {
  UsernameCreateScreen({Key? key}) : super(key: key);

  final RxBool usernameValid = RxBool(true);
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
                                      EdgeInsets.only(left: 8.0, bottom: 5.0),
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
                                  onTap: () {
                                    usernameValid.value = true;
                                  },
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
                            usernameValid.isFalse
                                ? SizedBox(
                                    height: 20.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "That username is already be taken!",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 20.0,
                            ),
                            CustomButton(
                                buttonlabel: "Continue",
                                buttoncolor: Colors.purple,
                                borderradius: 10.0,
                                leftmargin: 60.0,
                                rightmargin: 60.0,
                                onpressedfunction: () async {
                                  FocusScope.of(context).unfocus();
                                  String username =
                                      usernameController.text.trim();
                                  if (username != "") {
                                    await validateUsernameProfanity(
                                        username); // TODO: Complete username validations
                                    await validateUsernameUnique(username);
                                  }
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

  Future<bool> validateUsernameProfanity(String username) async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateUsernameUnique(String username) async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }
}
