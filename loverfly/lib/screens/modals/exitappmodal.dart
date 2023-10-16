import 'package:flutter/material.dart';
import 'package:loverfly/components/custombutton.dart';

class YesOrNoModal extends StatelessWidget {
  const YesOrNoModal({Key? key}) : super(key: key);

  // TODO: change all pages that are using modals to use one of these modals:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300.0,
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: Text(
                  "Are you sure you want to exit?",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      borderradius: 10.0,
                      buttoncolor: Colors.purple,
                      buttonlabel: "Yes",
                      leftpadding: 20.0,
                      rightpadding: 20.0,
                      onpressedfunction: () => Navigator.of(context).pop(true),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    CustomButton(
                      borderradius: 10.0,
                      buttoncolor: Colors.purple,
                      buttonlabel: "No",
                      onpressedfunction: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
