import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loverfly/components/customappbar.dart';
import 'package:loverfly/features/listviewscreens/api/listviewscreenapi.dart';
import 'package:loverfly/features/listviewscreens/listadmirers/admirerlistitem.dart';
import 'package:loverfly/utils/pageutils.dart';

class ListAdmirersScreen extends StatelessWidget {
  ListAdmirersScreen({
    Key? key,
  }) : super(key: key);

  final RxList admirers = RxList([]);
  final RxString nextPageLink = RxString("");
  final RxBool loadingAdmirers = RxBool(true);

  void preparePageData(context) async {
    getAllAdmirers(context);
  }

  void getAllAdmirers(context) async {
    try {
      await getAdmirersFromServer("").then((Map response) {
        if (response["api_response"] == "success") {
          admirers.value = response["admirers"];
          response["next_page_link"] != null
              ? nextPageLink.value = response["next_page_link"]
              : nextPageLink.value = "";
          loadingAdmirers.value = false;
        } else {
          loadingAdmirers.value = false;
          throw Exception();
        }
      });
    } catch (e) {
      SnackBars().displaySnackBar(
          "There was an error loading this page.", () => null, context);
    }
  }

  void addMorePaginatedAdmirers() {
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
      appBar: customAppBar(context, ''),
      body: Obx(
        () => !loadingAdmirers.value
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: admirers.isNotEmpty
                    ? Column(
                        children: [
                          // list container:
                          Expanded(
                            child: ListView.builder(
                                itemCount: admirers.length,
                                itemBuilder: (context, index) {
                                  if (index + 1 == admirers.length) {
                                    addMorePaginatedAdmirers();
                                  }
                                  return AdmirerListItem(
                                    admirerData: admirers[index],
                                  );
                                }),
                          ),
                        ],
                      )
                    : const SizedBox(
                        child: Center(
                          child: Text(
                            "Your relationship currently has no admirers.",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.purple),
                          ),
                        ),
                      ),
              )
            : const Center(
                child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      color: Colors.purple,
                    )),
              ),
      ),
    );
  }
}
