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
      // ignore: avoid_print
      print("send message!");
      widget.chatroom.lastmsg = userMsg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());
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
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(widget.chatroom.chatroomid)
                            .collection("messages")
                            .orderBy('createon', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              QuerySnapshot querySnapshot =
                                  snapshot.data as QuerySnapshot;
                              return ListView.builder(
                                reverse: true,
                                itemBuilder: (context, index) {
                                  MessageModel messageModel =
                                      MessageModel.fromMap(
                                          querySnapshot.docs[index].data()
                                              as Map<String, dynamic>);
                                  return Row(
                                    mainAxisAlignment: (messageModel.sender ==
                                            widget.userModel.uid)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 8),
                                          decoration: BoxDecoration(
                                              color: (messageModel.sender ==
                                                      widget.userModel.uid)
                                                  ? Colors.grey
                                                  : Colors.blue,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          child: Text(
                                            messageModel.text.toString(),
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          )),
                                    ],
                                  );
                                },
                                itemCount: querySnapshot.docs.length,
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                    "Error accoured plz check inter connection."),
                              );
                            } else {
                              return const Center(
                                child: Text("Say hi to your new friend"),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })),
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
