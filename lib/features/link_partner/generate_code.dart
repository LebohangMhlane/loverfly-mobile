import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/components/app_bar.dart';
import '../../components/custom_button.dart';
import 'api/link_partner_api_functions.dart';

class GenerateCodeScreen extends StatelessWidget {
  GenerateCodeScreen({Key? key}) : super(key: key);

  final Rx<String> code = Rx("");
  final Rx<String> message =
      Rx("Your partner must enter this code to link your accounts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300),
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
            onpressedfunction: () async {
              try {
                var cache = GetStorage();
                await generateLinkCode().then((Map generatedCode) {
                  cache.write("generatedCode", generatedCode["code"]);
                  code.value = generatedCode["code"];
                });
              } catch (e) {
                message.value = e.toString();
              }
            },
            borderradius: 20.0,
            buttoncolor: Colors.white,
            textcolor: Colors.purple,
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
                  style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300),
                )),
          )),
        ],
      ),
    );
  }
}
