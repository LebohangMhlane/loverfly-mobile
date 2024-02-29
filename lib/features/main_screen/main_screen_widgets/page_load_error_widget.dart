import 'package:flutter/material.dart';
import 'package:loverfly/components/custombutton.dart';

class PageLoadErrorWidget extends StatelessWidget {
  const PageLoadErrorWidget({
    Key? key,
    required this.logOutFunction,
  }) : super(key: key);

  final Function logOutFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80.0,),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text("There was an error loading this page. Please log out and try again.",
                style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
        ),
        const SizedBox(height: 50.0,),
          CustomButton(
          onpressedfunction: () async {
            await Future.delayed(const Duration(milliseconds: 250));
            logOutFunction(context);
          },
          borderradius: 10.0,
          buttoncolor: Colors.purple,
          buttonlabel: "Log Out",
        ),
      ],
    );
  }
}