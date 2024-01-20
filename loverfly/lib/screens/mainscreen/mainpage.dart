import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loverfly/api/authentication/signinscreen.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/components/custombutton.dart';
import 'package:loverfly/screens/coupleexplorerscreen/coupleexplorerpage.dart';
import 'package:loverfly/screens/mainscreen/couplepost/couplepost.dart';
import 'package:loverfly/screens/mainscreen/mainpageprovider.dart';
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

  void logOut(context) async {
    try {
      cache.erase();
      Get.off(()=>SignInScreen());
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
      builder: (context, mainPageProvider, child) => PopScope(
        onPopInvoked: (canPop) async {
          bool exitApp = await showDialog(
            context: context,
            builder: (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300.0,
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 80.0),
                          child: Text(
                            "Are you sure you want to exit?",
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                width: 120.0,
                                borderradius: 10.0,
                                buttoncolor: Colors.purple,
                                buttonlabel: "Yes",
                                onpressedfunction: () =>
                                    Navigator.of(context).pop(true),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              CustomButton(
                                width: 120.0,
                                borderradius: 10.0,
                                buttoncolor: Colors.purple,
                                buttonlabel: "No",
                                onpressedfunction: () =>
                                    Navigator.of(context).pop(false),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          return;
        },
        child: Scaffold(
        key: _scaffoldKey,
        drawer: Container(
        color: Colors.white,
        width: 250.0,
        // drawer menu
        child: ListView(
          children: [
            const SizedBox(
              height: 100.0,
            ),
        
            // couple explorer button
            SizedBox(
              height: 60.0,
              child: CustomButton(
                buttonlabel: 'Couple Explorer',
                textfontsize: 12.0,
                buttoncolor: Colors.purple,
                onpressedfunction: () async {
                  await Future.delayed(const Duration(milliseconds:250));
                  _scaffoldKey.currentState!.closeDrawer();
                  Get.to(()=>CoupleExplorerScreen());
                },
              ),
            ),
        
            // button 2
            Container(
              height: 60.0,
              color: Colors.blue,
            ),
        
            //  button 3
            Container(
              height: 60.0,
              color: Colors.yellow,
              child: CustomButton(
                buttonlabel: "Log Out",
                textfontsize: 12.0,
                onpressedfunction: () {
                  logOut(context);
                },
              ),
            )
          ],
        ),
        
        ),
        appBar: customAppBar(context, ''),
        body: mainPageProvider.initializationError ?
        Column(
        children: [
        const SizedBox(height: 80.0,),
        const Center(
          child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("There was an error loading this page. Please log out and try again.",
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
          ),
          ),
        ),
        const SizedBox(height: 50.0,),
        CustomButton(
          onpressedfunction: () async {
            await Future.delayed(const Duration(milliseconds: 250));
            logOut(context);
          },
          borderradius: 10.0,
          buttoncolor: Colors.purple,
          buttonlabel: "Log Out",
        ),
        ],
        ) :
        
        Stack(children: [
        // main page:
        DefaultTabController(
        initialIndex: 0,
        length: 2,
        child:
        Column(
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

            // couple posts page:
            Container(
            child: mainPageProvider.loadingPage ?

              // loading indicator:
              const Center(
              child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                backgroundColor: Colors.white,
                color: Colors.purpleAccent,
              ),
              ),
              ) : 
              
              mainPageProvider.postProviders.isEmpty ?
              Column(
              children: [
                const SizedBox(height: 100.0),

                // welcome to loverfly text:
                const Center(
                child: Text('Welcome to LoverFly!',
                  style: TextStyle(
                  color: Colors.purple),
                )),

                const SizedBox(height: 50.0),

                // descriptive text:
                Container(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: const Text(
                  "It looks like you're not following any couples. Visit the Couple Explorer!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Colors.purple,
                  fontSize: 12.0,
                  fontWeight:
                  FontWeight.w300),
                ),
                ),

                const SizedBox(height: 50.0),

                // couple explorer navigation button:
                Container(
                width: 170.0,
                height: 60.0,
                color: Colors.white,
                child: CustomButton(
                  buttonlabel:
                  'Couple Explorer',
                  borderradius: 20.0,
                  buttoncolor: Colors.purple,
                  onpressedfunction: () async {
                    await Future.delayed(const Duration(milliseconds:250));
                    Get.to(() => CoupleExplorerScreen());
                  },
                ),
                ),

              ],
              ) :

              // couple post list view:
              ListView.builder(
              itemCount: mainPageProvider.postProviders.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {

                // trigger pagination when at the end of the list:
                if (index + 1 == mainPageProvider.postProviders.length) {
                  if (mainPageProvider.paginationLink != "") {
                  }
                }

              // couple post:
              return ChangeNotifierProvider<PostProvider>.value(
                value: mainPageProvider.postProviders[index],
                child: const CouplePost(
                ),
              );

              })
              ),

            // user profile page:
            MyProfile(openDrawer: (){ openDrawer(); }),
          ],
          ))),
        ])),
        ])),
      ),
    );
  }
}
