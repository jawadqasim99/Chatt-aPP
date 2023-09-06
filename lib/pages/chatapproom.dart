// import 'package:flutter/cupertino.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/models/chatroommodel.dart';
import 'package:chatapp/models/meassagemodel.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatAppRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseuser;
  const ChatAppRoom(
      {super.key,
      required this.chatroom,
      required this.firebaseuser,
      required this.targetUser,
      required this.userModel});

  @override
  State<ChatAppRoom> createState() => _ChatAppRoomState();
}

class _ChatAppRoomState extends State<ChatAppRoom> {
  TextEditingController msg = TextEditingController();

  void sendMsg() async {
    String userMsg = msg.text.trim();
    msg.clear();

    if (userMsg != "") {
      MessageModel messageModel = MessageModel(
          msgid: uuid.v1(),
          createon: DateTime.now(),
          seen: false,
          sender: widget.userModel.uid,
          text: userMsg);
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(messageModel.msgid)
          .set(messageModel.toMap());
      print("send message!");
    } else {
      print("error is a ${userMsg}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    NetworkImage(widget.targetUser.profilepic.toString()),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.targetUser.fullname.toString(),
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatroom.chatroomid)
                        .collection("messages")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot =
                              snapshot.data as QuerySnapshot;
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              MessageModel messageModel = MessageModel.fromMap(
                                  querySnapshot.docs[index].data()
                                      as Map<String, dynamic>);
                              return Text(messageModel.text.toString());
                            },
                            itemCount: querySnapshot.docs.length,
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text("Say another friend to hi!"),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text("Say another friend to hi!"),
                        );
                      }
                    },
                  ),
                )),
                Container(
                  color: Colors.grey[200],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Flexible(
                          child: TextField(
                        controller: msg,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter message'),
                      )),
                      IconButton(
                          onPressed: () {
                            sendMsg();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
