import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreenprovider.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/utils/pageutils.dart';
import 'package:provider/provider.dart';
import 'authenticationapi.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final Rx<bool> signInStatus = Rx(true);
  final Rx<String> signInResponse = Rx("");
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final RxBool signingIn = RxBool(false);

  void processFormData(context) async {
    final auth = AuthenticationAPI();
    try {
      String username = _usernameTextController.text.trim();
      String password = _passwordTextController.text.trim();
      if (username != "" && password != "") {
        var tokenResponse = await auth.getAndCacheAPIToken(
            username: username, password: password);
        if (tokenResponse.containsKey("token") &&
            tokenResponse["token"] != "") {
          Navigator.of(context).pushReplacementNamed("/mainPage");
        } else {
          context
              .read<SignInScreenProvider>()
              .updateSignInResponse(tokenResponse["error_info"]);
          signingIn.value = false;
        }
      }
    } catch (e) {
      SnackBars().displaySnackBar("Something went wrong. We're looking into it!", () => null, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        // logo:
        Padding(
        padding: const EdgeInsets.only(top: 100.0), 
        child: Center(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Transform(
            transform: Matrix4.rotationZ(6.0),
            child: Image.asset('assets/placeholders/logo.jpeg', width: 20.0,),
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

          // sign up welcome title:
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
              style: TextStyle(color: Colors.purple),
              children: <TextSpan>[
                TextSpan(
                text: "Welcome back you two!",
                ),
                TextSpan(
                text: "",
                style: TextStyle(fontWeight: FontWeight.w300)),
                TextSpan(
                text: "",
                ),
              ]),
            )),
          ),

          const SizedBox(height: 10.0,),

          // username field title:
          const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Text("Username",
            style: TextStyle(
            color: Color.fromRGBO(156, 39, 176, 1),
            fontWeight: FontWeight.w300),
          ),
          )
          ),

          const SizedBox(height: 8.0,),

          // username input field:
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
            context.read<SignInScreenProvider>().updateSignInResponse("");
            },
            controller: _usernameTextController,
            decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your username",
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0)),
          )
          ),

          const SizedBox(height: 16.0,),

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
            height: 8.0,
          ),

          // password input field:
          Container(
          margin: const EdgeInsets.only(left: 40.0, right: 40.0),
          decoration: BoxDecoration(
            border: Border.all(
            width: 0.5,
            color: const Color.fromRGBO(156, 39, 176, 1)),
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: TextFormField(
          obscureText: true,
          style: const TextStyle(fontSize: 13.0),
          onChanged: (value) {
          context
          .read<SignInScreenProvider>()
          .updateSignInResponse("");
          },
          controller: _passwordTextController,
          decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your password",
          contentPadding: EdgeInsets.only(left: 10.0, right: 10.0)),
          )),

          // sign in error:
          context.watch<SignInScreenProvider>().signInResponse == ""
              ? const SizedBox(
                  height: 20.0,
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 30.0, right: 30.0, bottom: 15.0),
                  child: Center(
                      child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.red, fontSize: 12.0),
                        children: <TextSpan>[
                          TextSpan(
                              text: context
                                  .watch<SignInScreenProvider>()
                                  .signInResponse,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300)),
                        ]),
                  )),
                ),

          // log in button:
          CustomButton(
            buttonlabel: context.watch<SignInScreenProvider>().signingIn
                ? "Signing in..."
                : "Sign in",
            fontWeight: FontWeight.w300,
            buttoncolor: Colors.purple,
            borderradius: 10.0,
            leftmargin: 60.0,
            rightmargin: 60.0,
            onpressedfunction: () {
              FocusScope.of(context).unfocus();
              if (_usernameTextController.text != "" &&
                  _passwordTextController.text != "") {
                context
                    .read<SignInScreenProvider>()
                    .updateSigningInStatus(true);
                processFormData(context);
              }
            },
          ),

          // register description text:
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/signUpScreen");
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, left: 30.0, right: 30.0, bottom: 30.0),
              child: Center(
                  child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                    style: TextStyle(color: Colors.purple, fontSize: 12.0),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Wait. You might be new here. If so, ",
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      TextSpan(
                        text: "register!",
                      ),
                      TextSpan(
                        text: "",
                      ),
                    ]),
              )),
            ),
          ),

          const SizedBox(
            height: 25.0,
          ),
        ],
      ),
      ),
    ));
  }
}
