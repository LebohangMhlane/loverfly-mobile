import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/api/authentication/signinscreenprovider.dart';
import 'package:loverfly/features/coupleexplorerscreen/coupleexplorerprovider/coupleexplorerpageprovider.dart';
import 'package:loverfly/features/view_couple_screen/coupleprofileprovider.dart';
import 'package:loverfly/features/view_couple_screen/viewcouple.dart';
import 'package:loverfly/features/largerpreviewscreen/largerpreviewscreen.dart';
import 'package:loverfly/features/mainscreen/mainscreen.dart';
import 'package:loverfly/features/mainscreen/mainscreenprovider/mainpageprovider.dart';
import 'package:loverfly/features/mainscreen/mainscreenprovider/userprofileprovider.dart';
import 'package:loverfly/features/myprofilescreen/myprofilescreen.dart';
import 'package:loverfly/features/signup/signupscreen/signupscreen.dart';
import 'package:loverfly/features/splashscreen/viewsplashscreen.dart';
import 'package:provider/provider.dart';
import 'features/coupleexplorerscreen/coupleexplorerpage.dart';
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
          create: (context) => MainPageProvider(),
        ),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => CoupleExplorerPageProvider()),
        ChangeNotifierProvider(create: (context) => ViewCoupleProvider(couple: {})),
      ],
      child: GetMaterialApp(
        title: 'LoverFly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        getPages: [
          GetPage(name: "/mainPage", page: () => const MainPage()),
          GetPage(name: "/splashScreen", page: () => const SplashScreen()),
          GetPage(name: "/signInScreen", page: () => SignInScreen()),
          GetPage(name: "/signUpScreen", page: () => SignUpScreen()),
          GetPage(name: "/coupleExplorerScreen", page: () => CoupleExplorerScreen()),
          GetPage(name: "/myProfileScreen", page: () => MyProfile(openDrawer: (){},)),
          GetPage(name: "/viewCoupleScreen", page: () => const ViewCouple(
            couple: {},
          ),),
          GetPage(name: "/largerPreviewScreen", page: () => const LargerPreviewScreen(
            image: "", 
            postId: 000, 
            isMyPost: false,
          )),
        ],
        initialRoute: '/splashScreen',
      ),
    );
  }
}
