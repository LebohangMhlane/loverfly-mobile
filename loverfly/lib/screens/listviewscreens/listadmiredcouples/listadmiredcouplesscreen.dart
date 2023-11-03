import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/screens/listviewscreens/api/listviewscreenapi.dart';
import 'package:loverfly/screens/listviewscreens/listadmirers/listadmirersscreen.dart';
import 'package:loverfly/utils/pageutils.dart';

class ListAdmiredCouplesScreen extends StatelessWidget {
  ListAdmiredCouplesScreen({Key? key, required this.listType})
      : super(key: key);

  final String listType;
  final RxList admirers = RxList([]);
  final RxString nextPageLink = RxString("");

  // build the page:
  void preparePageData(context) {
    getAllAdmirers(context);
  }

  // get the admirers from the server:
  void getAllAdmirers(context) async {
    try {
      await getAdmirersFromServer("").then((Map response) {
        if (response["api_response"] == "success") {
          admirers.value = response["admirers"];
          response["next_page_link"] != null
              ? nextPageLink.value = response["next_page_link"]
              : nextPageLink.value = "";
        } else {}
      });
    } catch (e) {
      SnackBars().displaySnackBar(
          "There was an error loading this page.", () => null, context);
    }
  }

  // add more admires through pagination:
  void addMoreAdmirers() {
    if (nextPageLink.value != "") {
      getAdmirersFromServer(nextPageLink.value).then((Map response) {
        admirers.addAll(response["admirers"]);
        response["next_page_link"] != null
            ? nextPageLink.value = response["next_page_link"]
            : nextPageLink.value = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    preparePageData(context);

    return Scaffold(
      appBar: customAppBar(context, listType),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // list container:
            Obx(
              () => Expanded(
                child: ListView.builder(
                    itemCount: admirers.length,
                    itemBuilder: (context, index) {
                      if (index + 1 == admirers.length) {
                        addMoreAdmirers();
                      }
                      return ListAdmirersScreen();
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
