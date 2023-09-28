import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/custombutton.dart';
import 'api/codescreensapi.dart';

class GenerateCodeScreen extends StatelessWidget {
  GenerateCodeScreen({Key? key}) : super(key: key);

  final Rx<String> code = Rx("");
  final Rx<String> message =
      Rx("Your partner must enter this code to link your accounts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Link partner"),
      body: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          const Center(
              child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              "Generate a link code to share with your partner, Keep it secret, you don't want someone else claiming you now, do you?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.purple, fontSize: 11.0),
            ),
          )),
          const SizedBox(
            height: 40.0,
          ),
          const Center(
              child: Text(
            "Generate Link Code",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 20.0),
          )),
          const SizedBox(
            height: 50.0,
          ),
          CustomButton(
            onpressedfunction: () {
              try {
                SharedPreferences.getInstance().then((db) {
                  generateLinkCode().then((codemap) {
                    db.setString("generated_code", codemap["code"]);
                    code.value = codemap["code"];
                  });
                });
              } catch (e) {
                message.value = e.toString();
              }
            },
            buttonlabel: "Generate Code",
            leftmargin: 20.0,
            rightmargin: 20.0,
          ),
          const SizedBox(
            height: 50.0,
          ),
          Center(
            child: Obx(() => Text(
                  code.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 30.0,
                  ),
                )),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Obx(() => Text(
                  message.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.purple, fontSize: 10.0),
                )),
          )),
        ],
      ),
    );
  }
}
