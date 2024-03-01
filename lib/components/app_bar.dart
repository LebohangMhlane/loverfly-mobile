
import 'package:flutter/material.dart';


PreferredSizeWidget customAppBar(context, title){
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 40.0,
    backgroundColor: Colors.white,
    elevation: 0.0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 15.0,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          child: Transform(
            child: Image.asset(
              'assets/placeholders/logo.jpeg',
              width: 20.0,
            ),
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(6.0),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 2.0),
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(
            'LoverFly '+ title,
            style: const TextStyle(fontSize: 13.0, color: Colors.purple),
          ),
        ),
      ],
    ),
  );
}