import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/screens/couplelink/generatecode.dart';
import 'package:loverfly/screens/couplelink/inputcode.dart';
import 'package:loverfly/screens/commentsscreen/commentsmainscreen.dart';
import 'package:loverfly/screens/couplescreen/viewcouple.dart';
import 'package:loverfly/screens/createapostscreen/createapost.dart';
import 'package:loverfly/screens/largerpreviewscreen/largerpreviewscreen.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import 'package:loverfly/screens/signupscreen/signupscreen.dart';
import 'package:loverfly/screens/splashscreen/viewsplashscreen.dart';
import 'package:loverfly/screens/myprofilescreen/myprofilescreen.dart';
import 'package:loverfly/screens/usernamecreatescreen/usernamecreatescreen.dart';
import 'package:loverfly/testpage.dart';
import 'screens/coupleexplorerscreen/viewcoupleexplorer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
    return GetMaterialApp(
      title: 'LoverFly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/signupscreen', page: () => SignUpScreen()),
        GetPage(
            name: '/usernamecreatescreen', page: () => UsernameCreateScreen()),
        GetPage(name: '/splashscreen', page: () => const SplashScreen()),
        GetPage(name: '/signinscreen', page: () => SignInScreen()),
        GetPage(name: '/mainscreen', page: () => MainScreen()),
        GetPage(
            name: '/myprofilescreen',
            page: () => MyProfile(
                  reloadPosts: () {},
                  couple: const {},
                  userProfile: const {},
                )),
        GetPage(
            name: '/coupleprofilescreen',
            page: () => CoupleProfileScreen(
                  couple: const {},
                  isfavourited: RxBool(false),
                  rebuildPageFunction: () {},
                )),
        GetPage(
            name: '/coupleexplorerscreen', page: () => CoupleExplorerScreen()),
        GetPage(
            name: '/createapostscreen',
            page: () => CreateAPostScreen(resetPageFunction: () {})),
        GetPage(name: '/generatecodescreen', page: () => GenerateCodeScreen()),
        GetPage(
            name: '/largerpreviewscreen',
            page: () => LargerPreviewScreen(
                  imageurl: "",
                  myImage: false,
                  postId: 000,
                  resetPage: () {},
                )),
        GetPage(name: '/inputcodescreen', page: () => InputCodeScreen()),
        GetPage(
            name: '/comments',
            page: () => CommentScreen(postId: 000, couple: const {})),

        // testing page:
        GetPage(name: '/testPage', page: () => MyWidget()),
      ],
      initialRoute: '/signinscreen',
    );
  }
}
