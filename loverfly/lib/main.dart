import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/api/authentication/signinscreenprovider.dart';
import 'package:loverfly/features/couple_explorer/coupleexplorerprovider/coupleexplorerpageprovider.dart';
import 'package:loverfly/features/models/couple.dart';
import 'package:loverfly/features/view_couple/view_couple_provider.dart';
import 'package:loverfly/features/view_couple/view_couple.dart';
import 'package:loverfly/features/larger_image_view_screen/largerpreviewscreen.dart';
import 'package:loverfly/features/main_screen/mainscreen.dart';
import 'package:loverfly/features/main_screen/main_screen_provider/main_screen_provider.dart';
import 'package:loverfly/features/my_profile/my_profile_provider.dart';
import 'package:loverfly/features/my_profile/my_profile.dart';
import 'package:loverfly/features/sign_up/signupscreen/signupscreen.dart';
import 'package:loverfly/features/lazy_splash_screen/viewsplashscreen.dart';
import 'package:provider/provider.dart';
import 'features/couple_explorer/coupleexplorerpage.dart';
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
        ChangeNotifierProvider(create: (context) => ViewCoupleProvider(couple: Couple.createFromJson({}))),
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
          GetPage(name: "/viewCoupleScreen", page: () => ViewCouple(
            couple: Couple.createFromJson({}),
            isAdmired: false,
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
