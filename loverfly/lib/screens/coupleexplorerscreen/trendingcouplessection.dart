import 'package:flutter/material.dart';
import 'package:loverfly/screens/coupleexplorerscreen/trendingcouplesprovider.dart';
import 'package:provider/provider.dart';

class TrendingCouples extends StatelessWidget {
  const TrendingCouples(
      {Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrendingCouplePageProvider(),
      child: Consumer<TrendingCouplePageProvider>(
        builder: (context, trendingCouplePageProvider, child) => SizedBox(
        height: 100.0,
        child: Column(
          children: [
        
            // trending title:
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: Text(
                    'Trending',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                      color: Colors.purple),
                  ),
                ),
              ),
            ),
        
            // list of trending couples:
            Expanded(
              child: Padding( 
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0, right: 10.0, left: 10.0),
                child: SizedBox(
                  child: trendingCouplePageProvider.initializationError ?
                  const Center(child: Text("Failed to load trending couples",
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w300, fontSize: 12.5),
                  ),) :
                  ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingCouplePageProvider.trendingCoupleProviders.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<TrendingCoupleProvider>.value(
                      value: trendingCouplePageProvider.trendingCoupleProviders[index],
                      child: Consumer<TrendingCoupleProvider>(
                        builder: (context, trendingCoupleProvider, child) => GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                                width: 110.0,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      
                                      // couple partner 1
                                      Positioned(
                                        left: 60.0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            100.0)),
                                                color: Colors.purple),
                                            padding: const EdgeInsets.all(1.0),
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircleAvatar(
                                              backgroundImage:
                                              trendingCoupleProvider.partnerOneProfilePic == "" ?
                                              const NetworkImage("https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg") :
                                              NetworkImage(trendingCoupleProvider.partnerOneProfilePic),
                                              radius: 40.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                          
                                      // couple partner 2
                                      Positioned(
                                        top: 15.0,
                                        left: 17.0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            100.0)),
                                                color: Colors.purple),
                                            padding:
                                                const EdgeInsets.all(1.0),
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircleAvatar(
                                              backgroundImage: 
                                              trendingCoupleProvider.partnerOneProfilePic == "" ?
                                              const NetworkImage("https://www.omgtb.com/wp-content/uploads/2021/04/620_NC4xNjE-1-scaled.jpg") :
                                              NetworkImage(trendingCoupleProvider.partnerTwoProfilePic),
                                              radius: 25.0,
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )),
                          ),
                      ),
                    );
                  }),
                  )),
              ),
          ],
        ),
        ),
      ),
    );
  }

}
