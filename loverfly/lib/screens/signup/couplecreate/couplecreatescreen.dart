import 'package:flutter/material.dart';
import 'package:loverfly/components/custombutton.dart';

class CoupleCreateScreen extends StatelessWidget {
  const CoupleCreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(children: [
            // logo: // TODO: should make the logo it's own widget:
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.0,
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
            ),
            const SizedBox(
              height: 50.0,
            ),
            // question:
            const SizedBox(
              height: 30.0,
              child: Text(
                "Are you single?",
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.w300),
              ),
            ),
            // couple creation menus:
            Container(
              height: 350.0,
              color: Colors.white,
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Column(
                  children: [
                    // tab bar buttons:
                    Container(
                      height: 55.0,
                      color: Colors.purple,
                      child: const TabBar(
                          indicatorColor: Colors.purpleAccent,
                          tabs: [
                            Tab(
                              child: Expanded(
                                child: Text("Yes"),
                              ),
                            ),
                            Tab(
                              child: Expanded(
                                child: Text("No"),
                              ),
                            ),
                          ]),
                    ),
                    // tab bar views:
                    Expanded(
                        child: TabBarView(
                      children: [
                        // single user:
                        SizedBox(
                          child: Column(
                            children: [
                              // encouragement text:
                              const Expanded(
                                flex: 3,
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 70.0,
                                        child: Center(
                                          child: Text(
                                            "Aww!",
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Text(
                                          "That's okay! We at LoverFly believe there is someone for everyone. You just haven't met them yet, but you will! We do however restrict some features for single people using the app to mitigate abuse of couples by, let's say 'bitter' single people, but you may still enjoy admiring couples that inspire you and liking the memories they share!",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // continue single button:
                              Expanded(
                                child: Container(
                                  color: Colors.blue,
                                  child: CustomButton(
                                    buttonlabel: "Continue Single",
                                    buttoncolor: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // taken user:
                        SizedBox(
                          child: Column(
                            children: [
                              // encouragement text:
                              const Expanded(
                                flex: 3,
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 90.0,
                                        child: Center(
                                          child: Text(
                                            "Awwesome!!!",
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Text(
                                          "You and your significant other get to enjoy LoverFLy at it's fullest! Simply have your partner download LoverFly and finish the sign up process to get your accounts linked!",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // continue single button:
                              Expanded(
                                child: Container(
                                  color: Colors.blue,
                                  child: CustomButton(
                                    buttonlabel: "Continue Taken",
                                    buttoncolor: Colors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
