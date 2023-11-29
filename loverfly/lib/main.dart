import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/api/authentication/signinscreenprovider.dart';
import 'package:loverfly/screens/couplescreen/viewcouple.dart';
import 'package:loverfly/screens/mainscreen/mainscreen.dart';
import 'package:loverfly/screens/mainscreen/mainscreenprovider.dart';
import 'package:loverfly/screens/mainscreen/userprofileprovider.dart';
import 'package:loverfly/screens/signup/signupscreen/signupscreen.dart';
import 'package:loverfly/screens/splashscreen/viewsplashscreen.dart';
import 'package:provider/provider.dart';
import 'screens/coupleexplorerscreen/viewcoupleexplorer.dart';
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
      ],
      child: MaterialApp(
        title: 'LoverFly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/mainScreen": (context) => MainScreen(
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
        // routes: [
        //   GetPage(name: '/signupscreen', page: () => SignUpScreen()),
        //   GetPage(
        //       name: '/usernamecreatescreen', page: () => UsernameCreateScreen()),
        //   GetPage(name: '/splashscreen', page: () => const SplashScreen()),
        //   GetPage(name: '/signinscreen', page: () => SignInScreen()),
        //   GetPage(
        //       name: '/mainscreen',
        //       page: () => MainScreen(
        //           )),
        //   GetPage(
        //       name: '/myprofilescreen',
        //       page: () => MyProfile(
        //             scaffoldKey: GlobalKey(),
        //             reloadPosts: () {},
        //           )),
        //   GetPage(
        //       name: '/coupleprofilescreen',
        //       page: () => CoupleProfileScreen(
        //             couple: const {},
        //             isAdmired: RxBool(false),
        //             rebuildPageFunction: () {},
        //           )),
        //   GetPage(
        //       name: '/coupleexplorerscreen', page: () => CoupleExplorerScreen()),
        //   GetPage(
        //       name: '/createapostscreen',
        //       page: () => CreateAPostScreen(resetPageFunction: () {})),
        //   GetPage(name: '/generatecodescreen', page: () => GenerateCodeScreen()),
        //   GetPage(
        //       name: '/largerpreviewscreen',
        //       page: () => LargerPreviewScreen(
        //             imageurl: "",
        //             myImage: false,
        //             postId: 000,
        //             resetPage: () {},
        //           )),
        //   GetPage(name: '/inputcodescreen', page: () => InputCodeScreen()),
        //   GetPage(
        //       name: '/comments',
        //       page: () => CommentScreen(
        //             postId: 000,
        //             couple: const {},
        //             updateCommentCount: () {},
        //           )),
        //   GetPage(name: '/listview', page: () => ListAdmirersScreen()),
        //   GetPage(
        //       name: '/editprofilepicturescreen',
        //       page: () => EditProfilePictureScreen(
        //             currentProfilePicture: "",
        //             reloadProfilePage: () {},
        //           )),

        //   // testing page:
        //   GetPage(name: '/testPage', page: () => MyWidget()),
        initialRoute: '/splashScreen',
      ),
    );
  }
}
