      // child: Row(
      //               children: [
      //                 // favourite couple button
      //                 // hide favourite and like button if this is my post
      //                 ismypost.value
      //                 ? Expanded(child: Container())
      //                 : Expanded(
      //                     flex: 1,
      //                     child: TextButton(
      //                       onPressed: () async {
      //                         API().favourite(couple["username"], isfavourited.value).then((responsebool) {
      //                           setState(() {
      //                             if (responsebool != 'error') {
      //                               isfavourited.value = responsebool;
      //                               if (responsebool == false) {
      //                                 if (fans.value != 0) {
      //                                   fans.value--;
      //                                 }
      //                               } else {
      //                                 fans.value++;
      //                               }
      //                             }
      //                           });
      //                         });
      //                       },
      //                       child: Container(
      //                           padding: const EdgeInsets.all(0.0),
      //                           child: Container(
      //                             child: Column(
      //                               children: [
      //                                 Expanded(
      //                                   flex: 2,
      //                                   child: Container(
      //                                     alignment: Alignment.bottomCenter,
      //                                     padding: const EdgeInsets.only(
      //                                         bottom: 6.0),
      //                                     child: const Text('Favourite',
      //                                         style: TextStyle(
      //                                           fontWeight: FontWeight.w700,
      //                                           color: Colors.black,
      //                                           fontSize: 12.0,
      //                                         )),
      //                                   ),
      //                                 ),
      //                                 Expanded(
      //                                   flex: 2,
      //                                   child: Obx(() => Container(
      //                                       alignment: Alignment.topCenter,
      //                                       padding: const EdgeInsets.only(
      //                                           top: 0.0),
      //                                       child: SvgPicture.asset(
      //                                         'assets/svg/heart.svg',
      //                                         color: isfavourited.value
      //                                             ? Colors.red
      //                                             : Colors.grey[300],
      //                                         width: 20.0,
      //                                       ))),
      //                                 ),
      //                               ],
      //                             ),
      //                           )),
      //                     )),

      //                 const VerticalDivider(
      //                   indent: 20.0,
      //                   endIndent: 20.0,
      //                   thickness: 1.0,
      //                   width: 2.0,
      //                 ),

      //               // RELATIONSHIP STAGE and LIKE BUTTON
      //               Expanded(
      //                 flex: 2,
      //                 child: Container(
      //                   color: Colors.white,
      //                   alignment: Alignment.center,
      //                   child: Row(children: [
      //                     // RELATIONSHIP STAGE STATUS
      //                     // Expanded(
      //                     //     child: Container(
      //                     //   padding: const EdgeInsets.only(bottom: 10.0),
      //                     //   alignment: Alignment.center,
      //                     //   child: Column(
      //                     //     mainAxisAlignment: MainAxisAlignment.center,
      //                     //     children: [
      //                     //       // Container(
      //                     //       //   child: couple['relationship_status'] ==
      //                     //       //           'Dating'
      //                     //       //       ? SvgPicture.asset(
      //                     //       //           'assets/svg/twohearts.svg',
      //                     //       //           width: 15.0,
      //                     //       //           color: Colors.redAccent)
      //                     //       //       : couple['relationship_status'] ==
      //                     //       //               'Engaged'
      //                     //       //           ? SvgPicture.asset(
      //                     //       //               'assets/svg/rings1.svg',
      //                     //       //               width: 15.0,
      //                     //       //               color: Colors.blue)
      //                     //       //           : couple['relationship_status'] ==
      //                     //       //                   'Married'
      //                     //       //               ? SvgPicture.asset(
      //                     //       //                   'assets/svg/rings2.svg',
      //                     //       //                   width: 15.0,
      //                     //       //                   color: Colors.pink[400])
      //                     //       //               : Container(),
      //                     //       // ),
      //                     //       const SizedBox(height: 5.0),
      //                     //       Text(couple['relationship_status'],
      //                     //         style: const TextStyle(
      //                     //         color: Colors.purple,
      //                     //         fontWeight: FontWeight.w600,
      //                     //         letterSpacing: 1.0,
      //                     //         fontSize: 11.0)),
      //                     //     ],
      //                     //   ),
      //                     //   )
      //                     // ),

      //                     // LIKE BUTTON
      //                     // ismypost.value
      //                     // ? Expanded(child: Container())
      //                     // : Expanded(
      //                     //     child: Container(
      //                     //       child: const Center(
      //                     //       child: Text(
      //                     //         '.',
      //                     //         style: TextStyle(
      //                     //             color: Colors.purple),
      //                     //       ),
      //                     //     )
      //                     //     )
      //                     //   ),
      //                     //   TextButton(
      //                     //     onPressed: () async {
      //                     //       // like or unlike the users post
      //                     //       var postliked = '';
      //                     //       isliked.value == true
      //                     //           ? postliked = 'true'
      //                     //           : postliked = 'false';
      //                     //       API().likepost(post['id'], postliked).then((responsebool) {
      //                     //         setState(() {
      //                     //           if (responsebool != 'error') {
      //                     //             isliked.value = responsebool;
      //                     //           }
      //                     //         });
      //                     //       });
      //                     //     },
      //                     //     child: Container(
      //                     //       alignment: Alignment.center,
      //                     //       child: Row(
      //                     //         children: [
      //                     //           Expanded(
      //                     //               child: Container(
      //                     //             alignment:
      //                     //                 Alignment.center,
      //                     //             child: Obx(() => Icon(
      //                     //                 Icons.thumb_up,
      //                     //                 color: isliked.value
      //                     //                 ? Colors.purple[800]
      //                     //                 : Colors.grey[300],
      //                     //                 size: 20.0,
      //                     //               )),
      //                     //           )),
      //                     //           Expanded(
      //                     //             child: Container(
      //                     //             alignment:
      //                     //                 Alignment.center,
      //                     //             child: const Text(".",
      //                     //               style: TextStyle(
      //                     //                   fontSize: 12.0,
      //                     //                   color:
      //                     //                       Colors.black),
      //                     //             ),
      //                     //           ))
      //                     //         ],
      //                     //       )),
      //                     //   ),

      //                 const VerticalDivider(
      //                   indent: 20.0,
      //                   endIndent: 20.0,
      //                   thickness: 1.0,
      //                   width: 2.0,
      //                 ),

      //                 // COMMENT BUTTON
      //                 // Expanded(
      //                 //   flex: 1,
      //                 //   child: Container(
      //                 //       decoration: const BoxDecoration(
      //                 //         borderRadius:
      //                 //             BorderRadius.all(Radius.circular(10.0)),
      //                 //       ),
      //                 //       child: Container(
      //                 //         child: TextButton(
      //                 //           onPressed: () {
      //                 //             // widget.callbackfunction();
      //                 //           },
      //                 //           child: Container(
      //                 //             alignment: Alignment.center,
      //                 //             child: const Icon(
      //                 //               Icons.comment,
      //                 //               color: Colors.purple,
      //                 //               size: 25.0,
      //                 //             ),
      //                 //           ),
      //                 //         ),
      //                 //       )
      //                 //   ),
      //                 // )
                      
      //               ],




























      
            // // profile picture and favouriter count
            // Container(
            //     child: Row(
            //       children: [
            
            //         // profile picture
            //         Expanded(
            //           flex: 1,
            //           child: Container(
            //             padding: const EdgeInsets.only(top: 10.0),
            //             child: Column(
            //               children: [
            //                 Expanded(
            //                   flex: 2,
            //                   child: Container(
            //                     alignment: Alignment.center,
            //                     child: Container(
            //                       decoration: const BoxDecoration(
            //                           borderRadius: BorderRadius.all(Radius.circular(100.0)),
            //                           color: Colors.purple),
            //                       padding: const EdgeInsets.all(3.0),
            //                       width: 60.0,
            //                       height: 60.0,
            //                       // picture
            //                       child: CircleAvatar(
            //                         backgroundImage: NetworkImage(couple['profile_picture']),
            //                         radius: 25.0,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            
            //         const VerticalDivider(
            //           indent: 20.0,
            //           endIndent: 20.0,
            //           thickness: 1.0,
            //           width: 2.0,
            //         ),
            
            //         // fan counter
            //         Expanded(
            //           flex: 1,
            //           child: Container(
            //             padding: const EdgeInsets.only(top: 10.0),
            //             child: Column(
            //               children: [
            
            //                 // fans text
            //                 Expanded(
            //                   flex: 2,
            //                   child: Container(
            //                     alignment: Alignment.center,
            //                     child: const Text(
            //                       'Fans',
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 13.0),
            //                     ),
            //                   ),
            //                 ),
            
            //                 // heart svg
            //                 Expanded(
            //                   flex: 1,
            //                   child: Container(
            //                       alignment: Alignment.center,
            //                       child: SvgPicture.asset(
            //                         'assets/svg/heart.svg',
            //                         width: 20.0,
            //                         color: Colors.lightBlue,
            //                       )),
            //                 ),
            
            //                 // fan count
            //                 Expanded(
            //                   flex: 2,
            //                   child: Container(
            //                     alignment: Alignment.center,
            //                     child: Text(couple["number_of_fans"].toString(),
            //                       style: const TextStyle(
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 11.0,),
            //                     ))
            //                 ),
            
            //               ],
            //             ),
            //           ),
            //         ),
            
            //         const VerticalDivider(
            //           indent: 20.0,
            //           endIndent: 20.0,
            //           thickness: 1.0,
            //           width: 2.0,
            //         ),
            
            //         // PROFILE PICTURE USER 2
            //         Expanded(
            //           flex: 1,
            //           child: GestureDetector(
            //             onTap: () {},
            //             child: Container(
            //               padding: const EdgeInsets.only(top: 10.0),
            //               child: Column(
            //                 children: [
            //                   Expanded(
            //                     flex: 2,
            //                     child: Container(
            //                       alignment: Alignment.center,
            //                       child: Container(
            //                         decoration: const BoxDecoration(
            //                             borderRadius: BorderRadius.all(
            //                                 Radius.circular(100.0)),
            //                             color: Colors.purple),
            //                         padding: const EdgeInsets.all(3.0),
            //                         width: 60.0,
            //                         height: 60.0,
            //                         child: CircleAvatar(
            //                           backgroundImage: NetworkImage(jsonDecode(couple['partner_data'])["profile_picture"]),
            //                           radius: 25.0,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

            // // couple posted image
            // Expanded(
            //   flex: 6,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     alignment: Alignment.center,
            //     padding: const EdgeInsets.all(5.0),
            //     child: Stack(
            //       alignment: Alignment.bottomCenter,
            //       children: [
            //         // image
            //         Container(
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 image: DecorationImage(
            //               fit: BoxFit.cover,
            //               alignment: FractionalOffset.center,
            //               image: NetworkImage(post['image']),
            //             )),
            //           ),
            //         ),

            //         // caption
            //         Opacity(
            //           opacity: 0.6,
            //           child: Container(
            //             alignment: Alignment.center,
            //             color: Colors.black,
            //             width: MediaQuery.of(context).size.width,
            //             height: 60.0,
            //             margin: const EdgeInsets.only(bottom: 40.0),
            //             child: Text(post['caption'],
            //                 style: const TextStyle(color: Colors.white)),
            //           ),
            //         ),

            //         // time, date and verification
            //         Container(
            //             alignment: Alignment.bottomCenter,
            //             padding: const EdgeInsets.only(
            //                 bottom: 12.0, right: 15.0, left: 15.0),
            //             child: Row(
            //               children: [
            //                 Expanded(
            //                   child: Container(
            //                     child: Text(
            //                       postdate['dayofweek'].toString() + ' - ' + postdate['date'],
            //                       style: const TextStyle(
            //                           color: Colors.white, fontSize: 12.0),
            //                     ),
            //                   ),
            //                 ),
            //                 Container(
            //                   child: Text(
            //                     couple['is_verified'] ? 'Verified' : '',
            //                     style: const TextStyle(
            //                       color: Colors.purple,
            //                       shadows: <Shadow>[
            //                         Shadow(
            //                           blurRadius: 3.0,
            //                           color: Colors.white,
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 )
            //               ],
            //             )),
            //       ],
            //     ),
            //   ),
            // ),

            // // user interactions
            // Expanded(
            //   flex: 1,
            //   child: Container(

            //     // favouriting button
            //     child: Expanded(
            //       flex: 1,
            //       child: Container(
            //         child: Column(
            //           children: [
            //             Container(
            //               alignment: Alignment.center,
            //               color: Colors.grey,
            //               child: TextButton(
            //                 onPressed: () {
            //                   print("pressed");
            //                 },
            //                 child: Container(
            //                   child: const Text("Press Me"),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       )
            //     ),
                
            //   ),
            // )
