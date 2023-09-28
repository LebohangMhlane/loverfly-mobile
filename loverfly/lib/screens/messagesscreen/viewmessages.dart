

// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageList extends StatefulWidget {
  const MessageList({ Key? key }) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

List _messages = [1, 2, 3, 1, 2, 3, 3, 3, 3,];

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [

          // MESSAGE LIST OPTIONS BAR
          Container(
            height: 100.0,
            color: Colors.deepPurple,
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.mail,
                                  size: 20.0,
                                  color: Colors.purple[100],
                                ),
                              ),
                              Positioned(
                                top: 0.0,
                                bottom: 11.0,
                                left: 6.5,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    "assets/svg/heart.svg",
                                    width: 10.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                        ),
                      )
                    ],)
                  ),
                ),

                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white,),
                  ),
                ),

              ],
            ),
          ),

          // MESSAGE LIST 
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, index){
                  return Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.white),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    width: 100.0,
                    height: 100.0,
                    child: Column(
                      children: [

                        Expanded(
                          child: Container(
                            child: Row(children: [
                              Expanded(child: Container(alignment: Alignment.center, child: const Text('Kai V Moriarty', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12.0),),),),
                              Expanded(flex:2, child: Container(padding: const EdgeInsets.only(right: 10.0), alignment: Alignment.centerRight, child: const Text('2 Feb', style: TextStyle(color: Colors.black),),))
                            ],)
                          )
                        ),

                        Expanded(
                          flex: 3,
                          child: Row(children: [
                              Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                            width: 65.0,
                                            height: 65.0,
                                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100.0)), color: Colors.purple),
                                            padding: const EdgeInsets.all(2.0),
                                            child: const CircleAvatar(
                                              backgroundImage: AssetImage('assets/placeholders/profilepic1.png'),
                                            )
                                        ),
                                      ),
                                    ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text('"Hello I read your profile and I am interested. Lets talk"', style: TextStyle(color: Colors.black),),
                                ),
                                )
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                }),
            ),
          ),

        ],
      ),

    );
  }
}