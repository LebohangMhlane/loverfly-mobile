import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          backgroundColor: Colors.white,
          color: Colors.purpleAccent,
        ),
      ),  
    );
  }
}