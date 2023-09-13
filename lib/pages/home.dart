import 'package:chatapp/models/chatroommodel.dart';
import 'package:chatapp/models/usermodelhelper.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/chatapproom.dart';
import 'package:chatapp/pages/loginpage.dart';
import 'package:chatapp/pages/serachpasge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Myhome extends StatefulWidget {
  final UserModel usermodel;
  final User firbaseuser;
  const Myhome({super.key, required this.firbaseuser, required this.usermodel});

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LogInPage()));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
        title: const Text(
          'Chat App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .where('users', arrayContains: widget.usermodel.uid)
                  .orderBy('createon', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshot.data as QuerySnapshot;
                    // print(querySnapshot.docs.length);
                    return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            querySnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        Map<String, dynamic> perticipents =
                            chatRoomModel.perticipent!;
                        List<String> perticipentkey =
                            perticipents.keys.toList();
                        perticipentkey.remove(widget.usermodel.uid);
                        return FutureBuilder(
                            future: FireBaseHelper.getUserModelId(
                                perticipentkey[0]),
                            builder: (context, userdata) {
                              if (userdata.connectionState ==
                                  ConnectionState.done) {
                                if (userdata.data != null) {
                                  UserModel targetuser =
                                      userdata.data as UserModel;
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChatAppRoom(
                                            chatroom: chatRoomModel,
                                            firebaseuser: widget.firbaseuser,
                                            targetUser: targetuser,
                                            userModel: widget.usermodel);
                                      }));
                                    },
                                    title: Text(
                                      targetuser.fullname.toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    subtitle: (chatRoomModel.lastmsg
                                                .toString() !=
                                            "")
                                        ? Text(chatRoomModel.lastmsg.toString())
                                        : const Text(
                                            "Say hi to your friend!",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            targetuser.profilepic!)),
                                    trailing: Text(
                                        "${chatRoomModel.createon!.hour.toString()}:${chatRoomModel.createon!.minute.toString()}"),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            });
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("No Chats"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SerachPage(
                      firebaseuser: widget.firbaseuser,
                      userModel: widget.usermodel)));
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}
