// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatAppRoom extends StatefulWidget {
  const ChatAppRoom({super.key});

  @override
  State<ChatAppRoom> createState() => _ChatAppRoomState();
}

class _ChatAppRoomState extends State<ChatAppRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: Column(
              children: [
                const Expanded(child: Text("")),
                Container(
                  color: Colors.grey[200],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: const Row(
                    children: [
                      Flexible(
                          child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter message'),
                      )),
                      Icon(
                        Icons.send,
                        color: Colors.blue,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
