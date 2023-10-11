import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final Color? buttoncolor;
  final Color textcolor;
  final Color splashcolor;
  final String buttonlabel;
  final double textfontsize;
  final double borderradius;
  final double borderwidth;
  final double leftmargin;
  final double rightmargin;
  final double leftpadding;
  final double rightpadding;
  final Color bordercolor;
  final BorderStyle? borderstyle;
  final Widget? customchild;
  final double height;
  final FontWeight fontWeight;
  Widget? icon;

  VoidCallback? onpressedfunction;

  CustomButton({
    Key? key,
    this.borderwidth = 0.0,
    this.bordercolor = Colors.transparent,
    this.borderstyle,
    this.textfontsize = 14.0,
    this.splashcolor = Colors.white,
    this.buttoncolor = Colors.black,
    this.textcolor = Colors.white,
    this.buttonlabel = 'Press Me',
    this.leftpadding = 0.0,
    this.rightpadding = 0.0,
    this.leftmargin = 0.0,
    this.rightmargin = 0.0,
    this.borderradius = 0.0,
    this.onpressedfunction,
    this.icon,
    this.customchild,
    this.height = 55.0,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(left: leftmargin, right: rightmargin),
      child: TextButton(
        onPressed: () {
          if (onpressedfunction != null) {
            onpressedfunction!();
          } else {}
        },
        child: customchild == null
            ? icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        buttonlabel,
                        style: TextStyle(
                          color: textcolor,
                        ),
                      )
                    ],
                  )
                : Container(
                    padding:
                        EdgeInsets.only(left: leftpadding, right: rightpadding),
                    alignment: Alignment.center,
                    child: Text(
                      buttonlabel,
                      style: TextStyle(
                        color: textcolor,
                        fontSize: textfontsize,
                        fontWeight: fontWeight,
                      ),
                    ))
            : Center(
                child: customchild,
              ),
        style: TextButton.styleFrom(
          side: BorderSide(
              width: borderwidth, color: bordercolor, style: BorderStyle.solid),
          foregroundColor: splashcolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderradius)),
          backgroundColor: buttoncolor,
        ),
      ),
    );
  }
}
