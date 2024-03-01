import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/custom_button.dart';
import 'package:loverfly/features/couple_explorer/couple_explorer.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const SizedBox(height: 100.0),

        // welcome to loverfly text:
        const Center(
        child: Text('Welcome to LoverFly!',
          style: TextStyle(
          color: Colors.purple),
        )),

        const SizedBox(height: 50.0),

        // descriptive text:
        Container(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: const Text(
          "It looks like you're not following any couples. Visit the Couple Explorer!",
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Colors.purple,
          fontSize: 12.0,
          fontWeight:
          FontWeight.w300),
        ),
        ),

        const SizedBox(height: 50.0),

        // couple explorer navigation button:
        Container(
        width: 170.0,
        height: 60.0,
        color: Colors.white,
        child: CustomButton(
          buttonlabel:
          'Couple Explorer',
          borderradius: 20.0,
          buttoncolor: Colors.purple,
          onpressedfunction: () async {
            await Future.delayed(const Duration(milliseconds:250));
            Get.to(() => CoupleExplorerScreen());
          },
        ),
        ),

      ],
      );
  }
}