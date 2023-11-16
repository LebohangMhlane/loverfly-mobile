import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdmirerListItem extends StatelessWidget {
  AdmirerListItem({Key? key, required this.admirerData}) : super(key: key);

  final Map admirerData;
  final RxString admirerProfilePicture = RxString("");
  final RxString username = RxString("");

  void prepareListItemData() {
    admirerProfilePicture.value = admirerData["admirer"]["profile_picture"] !=
            null
        ? admirerData["admirer"]["profile_picture"]["image"]
        : "http://www.buckinghamandcompany.com.au/wp-content/uploads/2016/03/profile-placeholder.png";
    username.value = admirerData["admirer"]["username"];
  }

  @override
  Widget build(BuildContext context) {
    prepareListItemData();
    return SizedBox(
      height: 74.0,
      child: Row(
        children: [
          // user profile picture:
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
                width: 80.0,
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        color: Colors.purple),
                    padding: const EdgeInsets.all(1.0),
                    width: 60.0,
                    height: 60.0,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(admirerProfilePicture.value),
                      radius: 25.0,
                    ),
                  ),
                )),
          ),
          // username:
          Expanded(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(username.value),
              ),
            ),
          )
        ],
      ),
    );
  }
}
