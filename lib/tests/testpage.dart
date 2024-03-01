
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loverfly/components/app_bar.dart';

class MyWidget extends StatelessWidget {

  MyWidget({Key? key}) : super(key: key);

  final Rx<Map> pagedata = Rx({});
  final Rx<String> text = Rx('Change Me');
  final Rx<int> postcount = Rx(0);

  @override
  Widget build(BuildContext context) {

    preparePageData();

    return SafeArea(
      child: Obx(()=> Scaffold(
          appBar: customAppBar(context, ''),
          body: Column(children: [

                  // // picture 2
                  // Expanded(
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     child: Container(
                  //       decoration: const BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  //         color: Colors.purple),
                  //       padding: const EdgeInsets.all(1.0),
                  //       width: 82.0,
                  //       child: CircleAvatar(
                  //         backgroundImage: NetworkImage(couple['partner_two']["profile_picture"]),
                  //         radius: 40.0,
                  //       ),
                  //     ),
                  //   ),
                  // ),
          
              GestureDetector(
                onTap: (){ 
                  pagedata.update((val) { val!["name"] = "Kai"; });
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  height: 70.0,
                  child: Text(pagedata.value["name"]),
                ),
              ),
      
            ]),
        ),
      ),
    );

  }


  void preparePageData(){
    pagedata.value["name"] = "Lebo";
  }


}

//   void getposts() {
//     API().getposts().then((value){
//       pagedata.value = value;
//       if (pagedata.value.isNotEmpty){
//         text.value = pagedata.value["posts"][postcount.value]["couple"]["username"];
//       }
//     });
//   }

//   void viewnextcouple() {
//     List posts = pagedata.value["posts"];
//     if (posts.isNotEmpty && posts.length > 1){
//       if (postcount.value == posts.length - 1){
//         postcount.value = 0;
//         text.value = posts[postcount.value]["couple"]["username"];
//       } else {
//         postcount.value++;
//         text.value = posts[postcount.value]["couple"]["username"];
//       }
//     } 
//   }

// }
