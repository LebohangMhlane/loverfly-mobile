import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/custombutton.dart';
import 'api/codescreensapi.dart';

class InputCodeScreen extends StatelessWidget {
  InputCodeScreen({Key? key}) : super(key: key);

  final Rx<String> code = Rx("");
  final Rx<String> message = Rx("Make sure the code is correct!");
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Link partner"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                "Have your significant other generate a code for you to link your accounts then input it below.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple, fontSize: 11.0),
              ),
            )),
            const SizedBox(
              height: 40.0,
            ),
            const Center(
                child: Text(
              "Type in a Link Code",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 20.0),
            )),
            const SizedBox(
              height: 50.0,
            ),
            Container(
              color: const Color.fromARGB(255, 212, 212, 212),
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: TextField(
                showCursor: false,
                controller: _textEditingController,
                onChanged: (value) {
                  if (_textEditingController.text.length == 5) {
                    FocusScope.of(context).unfocus();
                  } else if (_textEditingController.text.length > 5) {
                    _textEditingController.clear();
                  }
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 11.0),
                  hintText: "Enter a link code here",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            CustomButton(
              onpressedfunction: () {
                if (_textEditingController.text.length == 5) {
                  try {
                    SharedPreferences.getInstance().then((db) {
                      String code = _textEditingController.text;
                      if (db.containsKey("generatedcode") &&
                          db.get("generatedcode") == code) {
                        message.value =
                            "You cannot be in a relationship with yourself... Well, technically speaking...";
                      } else {
                        inputLinkCode(code).then((value) {
                          if (value.containsKey("error")) {
                            message.value = value["error"];
                          } else {
                            message.value = value["success"];
                          }
                        });
                      }
                    });
                  } catch (e) {
                    message.value = e.toString();
                  }
                }
              },
              buttonlabel: "Link",
              leftmargin: 20.0,
              rightmargin: 20.0,
            ),
            const SizedBox(
              height: 50.0,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Obx(
                () => Text(
                  message.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.purple, fontSize: 10.0),
                ),
              ),
            )),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
