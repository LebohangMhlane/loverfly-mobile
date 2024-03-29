import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final cache = GetStorage();

  @override
  void initState() {
    runappchecks();
    super.initState();
  }

  void runappchecks() async {
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      if (cache.hasData("token") && cache.read("token") != "") {
        if (cache.hasData("user_profile") && cache.read("user_profile") != "") {
          Navigator.of(context).pushReplacementNamed("/mainPage", arguments: {});
        } else {
          cache.erase();
          Navigator.of(context).pushReplacementNamed("/signInScreen");
        }
      } else {
        Navigator.of(context).pushReplacementNamed("/signInScreen");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.0,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: Transform(
                child: Image.asset(
                  'assets/placeholders/logo.jpeg',
                  width: 50.0,
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
              child: const Text(
                'LoverFly',
                style: TextStyle(fontSize: 17.0, color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
