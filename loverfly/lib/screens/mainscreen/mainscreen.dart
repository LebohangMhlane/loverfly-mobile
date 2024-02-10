import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/components/loadingIndicator.dart';
import 'package:loverfly/screens/mainscreen/drawer/drawerwidget.dart';
import 'package:loverfly/screens/mainscreen/mainScreenWidgets/couplePostWidget.dart';
import 'package:loverfly/screens/mainscreen/mainScreenWidgets/pageLoadErrorWidget.dart';
import 'package:loverfly/screens/mainscreen/mainscreenproviders/mainpageprovider.dart';
import 'package:loverfly/screens/mainscreen/mainscreenwidgets/welcome_widget.dart';
import 'package:loverfly/utils/pageutils.dart';
import 'package:provider/provider.dart';
import '../myprofilescreen/myprofilescreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({key,}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GetStorage cache = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer(){
    _scaffoldKey.currentState!.openDrawer();
  }

  void closeDrawer(){
    _scaffoldKey.currentState!.closeDrawer();
  }
  
  void logOut(context) async {
    try {
      final GetStorage cache = GetStorage();
      cache.erase();
      Get.off(() => SignInScreen());
    } catch (e) {
      SnackBars().displaySnackBar("There was an error logging out.", () => null, context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainPageProvider>(
      builder: (context, mainPageProvider, child) => Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(
          closeDrawerFunction: closeDrawer,
          logOutFunction: logOut,
        ),
        appBar: customAppBar(context, ''),
        body: mainPageProvider.initializationError ?
          PageLoadErrorWidget(
            logOutFunction: logOut,
          ) :
          Stack(
            children: [
              DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Column(
                  verticalDirection: VerticalDirection.up, 
                  children: [

                  // tab bar switch buttons:
                  Container(
                    height: 40.0,
                    color: Colors.black,
                    child: const TabBar(
                      indicatorColor: Colors.purple,
                      tabs: [
                      Tab(text: 'Couples'),
                      Tab(child: Icon(Icons.person)),
                      ],
                    ),
                  ),

                  // tab screens:
                  Expanded(
                  child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: TabBarView(
                    children: [
                      // couple post list:
                      Container(
                        child: mainPageProvider.loadingPage ?
                        // loading indicator:
                        const LoadingIndicator() : 
                        mainPageProvider.postProviders.isEmpty ?
                        const WelcomeWidget() :
                        // list couple posts:
                        ListView.builder(
                          itemCount: mainPageProvider.postProviders.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (index + 1 == mainPageProvider.postProviders.length) {
                              if (mainPageProvider.paginationLink != "") {
                                // get and add more posts to the list (pagination)
                              }
                            }
                            return ChangeNotifierProvider<PostProvider>.value(
                              value: mainPageProvider.postProviders[index],
                              child: const CouplePostWidget(
                              ),
                            );
                        })
                      ),
                
                      // user profile page:
                      MyProfile(openDrawer: openDrawer ),

                    ],
        ))),
      ])),
      ])),
    );
  }
}
