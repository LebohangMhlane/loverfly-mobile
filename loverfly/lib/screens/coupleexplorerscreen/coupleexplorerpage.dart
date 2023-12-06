import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/screens/coupleexplorerscreen/coupleexplorerprovider/coupleexplorerpageprovider.dart';
import 'package:loverfly/screens/coupleexplorerscreen/couplecard.dart';
import 'package:provider/provider.dart';
import '../../components/customappbar.dart';
import 'trendingcouplessection.dart';

class CoupleExplorerScreen extends StatelessWidget {
  CoupleExplorerScreen({
    Key? key,
  }) : super(key: key);

  final Rx<List> trendingCouplesList = Rx([]);
  final bool canPop = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CoupleExplorerPageProvider>(
      builder: (context, provider, widget){ 
        return PopScope(
        canPop: canPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: customAppBar(context, 'Couple Explorer'),
          body: provider.pageLoading ? 
          const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                color: Colors.purple,
              ),
            ),
          ) :
          // render lists:
          Column(
            children: [
            const TrendingCouples(),
            provider.coupleCardProviders.isEmpty ? 
            const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text("There are currently no couples to admire.",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        color: Colors.purple),
                  ),
                ),
              ) : 
              Expanded(
                flex: 5,
                child: ListView.builder(
                    itemCount: provider.coupleCardProviders.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider<CoupleCardProvider>.value(
                        value: provider.coupleCardProviders[index],
                        child: Consumer<CoupleCardProvider>(
                          builder: (context, coupleCardItemProvider, widget) {
                            return const CoupleCard();
                          },
                        ),
                      );
                    }),
              ),
            
            ],
          )
        ));}
    );
  }
}
