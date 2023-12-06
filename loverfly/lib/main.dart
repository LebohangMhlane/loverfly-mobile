import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/api/authentication/signinscreenprovider.dart';
import 'package:loverfly/screens/coupleexplorerscreen/coupleexplorerprovider/coupleexplorerpageprovider.dart';
import 'package:loverfly/screens/couplescreen/viewcouple.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import 'package:loverfly/screens/mainscreen/mainscreenprovider.dart';
import 'package:loverfly/screens/mainscreen/userprofileprovider.dart';
import 'package:loverfly/screens/signup/signupscreen/signupscreen.dart';
import 'package:loverfly/screens/splashscreen/viewsplashscreen.dart';
import 'package:provider/provider.dart';
import 'screens/coupleexplorerscreen/coupleexplorerpage.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize GetStorage:
  await GetStorage.init();

  // change status bar color to transparent:
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignInScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainScreenProvider(),
        ),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(
          create: (context) => CoupleExplorerPageProvider(),
        )
      ],
      child: MaterialApp(
        title: 'LoverFly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/mainScreen": (context) => const MainScreen(
                desiredPageIndex: 0,
              ),
          "/splashScreen": (context) => const SplashScreen(),
          "/signInScreen": (context) => SignInScreen(),
          "/signUpScreen": (context) => SignUpScreen(),
          "/coupleExplorerScreen": (context) => CoupleExplorerScreen(),
          "/viewCoupleScreen": (context) => CoupleProfileScreen(
                couple: const {},
                isAdmired: RxBool(false),
                rebuildPageFunction: () {},
              ),
        },
        initialRoute: '/splashScreen',
      ),
    );
  }
}
