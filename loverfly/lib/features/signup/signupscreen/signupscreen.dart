import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/features/signup/usernamecreate/usernamecreatescreen.dart';
import 'package:loverfly/utils/pageutils.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({
    Key? key,
  }) : super(key: key);

  // text field controllers:
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();

  // error notifiers:
  final RxBool emailValid = RxBool(true);
  final RxBool passwordValid = RxBool(true);
  final RxBool passwordsMatch = RxBool(true);

  // global form validator:
  final RxBool formIsValid = RxBool(false);

  // cache:
  final cache = GetStorage();

  void preparePageData() {}

  bool isPasswordValid(String password) {
    // check if the password contains at least 8 characters:
    if (password.length < 8) {
      return false;
      // check if the password contains at one capitalized letter:
    } else if (!password.runes.any((rune) => rune >= 65 && rune <= 90)) {
      return false;
      // check if the password contains at one numerical value:
    } else if (!password.runes.any((rune) => rune >= 48 && rune <= 57)) {
      return false;
    } else {
      return true;
    }
  }

  bool doPasswordsMatch(String passwordOne, passwordTwo) {
    // check if password one matches with password two:
    if (passwordOne == passwordTwo) {
      return true;
    }
    return false;
  }

  bool isEmailValid(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return emailRegExp.hasMatch(email);
  }

  Future<bool> saveToCache(String email, String password) async {
    try {
      await cache.erase();
      await cache.write("email", email);
      await cache.write("password", password);
      return true;
    } catch (e) {
      return false;
    }
  }

  void processFormData(context) {
    formIsValid.value = true;

    String email = emailTextController.text.trim();
    String password =
        passwordTextController.text.trim().replaceAll(RegExp(r'\s+'), '');
    String confirmPassword = confirmPasswordTextController.text
        .trim()
        .replaceAll(RegExp(r'\s+'), '');

    // validate the form data:
    if (!isEmailValid(email)) {
      emailValid.value = false;
      formIsValid.value = false;
    }
    if (!isPasswordValid(password)) {
      passwordValid.value = false;
      formIsValid.value = false;
    }
    if (!doPasswordsMatch(password, confirmPassword)) {
      passwordsMatch.value = false;
      formIsValid.value = false;
    }

    // verify everything is valid and process it:
    if (formIsValid.value) {
      try {
        saveToCache(email, password).then((saved) => {
              saved
                  ? SnackBars()
                      .displaySnackBar("Saved! Continuing with sign up.", () {
                      Get.to(() => UsernameCreateScreen());
                    }, context)
                  : SnackBars().displaySnackBar(
                      "Something went horribly wrong. We're fixing it. We promise!",
                      () {},
                      context)
            });
      } catch (e) {
        SnackBars().displaySnackBar(
            "Something went horribly wrong. We're fixing it. We promise!",
            () {},
            context);
      }
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
          child: Column(children: [
            // logo:
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
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
                        style: TextStyle(fontSize: 17.0, color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // sign Up title:
            Padding(
              padding: const EdgeInsets.only(
                  top: 50.0, left: 30.0, right: 30.0, bottom: 30.0),
              child: Center(
                  child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                    style: TextStyle(color: Colors.purple),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Oolala! ",
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: "A new LoverFly couple! ",
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      TextSpan(
                        text: "Welcome! ",
                      ),
                    ]),
              )),
            ),

            const SizedBox(
              height: 10.0,
            ),

            // fields:
            Obx(
              () => SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // email field title:
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: Color.fromRGBO(156, 39, 176, 1),
                                fontWeight: FontWeight.w300),
                          ),
                        )),

                    const SizedBox(
                      height: 8.0,
                    ),

                    // email input field:
                    Container(
                        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: const Color.fromRGBO(156, 39, 176, 1)),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 13.0),
                          onChanged: (value) {
                            emailValid.value = true;
                          },
                          controller: emailTextController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter an email",
                              contentPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0)),
                        )),

                    const SizedBox(
                      height: 8.0,
                    ),

                    // email field error:
                    emailValid.isFalse
                        ? SizedBox(
                            height: 20.0,
                            width: MediaQuery.of(context).size.width,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: Text(
                                "Please enter a valid email address",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          )
                        : const SizedBox(),

                    const SizedBox(
                      height: 15.0,
                    ),

                    // password field title:
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: Text(
                            "Password",
                            style: TextStyle(
                                color: Color.fromRGBO(156, 39, 176, 1),
                                fontWeight: FontWeight.w300),
                          ),
                        )),

                    const SizedBox(
                      height: 6.0,
                    ),

                    // password input field:
                    Container(
                        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: const Color.fromRGBO(156, 39, 176, 1)),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 13.0),
                          onChanged: (value) {
                            passwordValid.value = true;
                          },
                          controller: passwordTextController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter a password",
                              contentPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0)),
                        )),

                    const SizedBox(
                      height: 8.0,
                    ),

                    // password error:
                    passwordValid.isFalse
                        ? SizedBox(
                            height: 20.0,
                            width: MediaQuery.of(context).size.width,
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 40.0,
                              ),
                              child: Text(
                                "Please enter a valid password",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          )
                        : const SizedBox(),

                    const SizedBox(
                      height: 7.0,
                    ),

                    // password instructions:
                    const Padding(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      child: SizedBox(
                        height: 40.0,
                        child: Text(
                          "Password must be at least 8 characters long with at least one capitalized letter, special character, and numerical character. White spaces will not be recognized.",
                          style: TextStyle(
                              fontSize: 11.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    // confirm passowrd field title:
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: Text(
                            "Confirm Password",
                            style: TextStyle(
                                color: Color.fromRGBO(156, 39, 176, 1),
                                fontWeight: FontWeight.w300),
                          ),
                        )),

                    const SizedBox(
                      height: 6.0,
                    ),

                    // confirm password input field:
                    Container(
                        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: const Color.fromRGBO(156, 39, 176, 1)),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 13.0),
                          onChanged: (value) {
                            passwordValid.value = true;
                            passwordsMatch.value = true;
                          },
                          controller: confirmPasswordTextController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter password again",
                              contentPadding:
                                  EdgeInsets.only(left: 10.0, right: 10.0)),
                        )),

                    const SizedBox(
                      height: 8.0,
                    ),

                    passwordsMatch.isFalse
                        ? SizedBox(
                            height: 20.0,
                            width: MediaQuery.of(context).size.width,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 40.0),
                              child: Text(
                                "Passwords don't match",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w300),
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
                      onpressedfunction: () {
                        FocusScope.of(context).unfocus();
                        processFormData(context);
                      },
                    ),
                    const SizedBox(
                      height: 50.0,
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
