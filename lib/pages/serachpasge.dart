import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/chatapproom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SerachPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  const SerachPage(
      {super.key, required this.firebaseuser, required this.userModel});

  @override
  State<SerachPage> createState() => _SerachPageState();
}

class _SerachPageState extends State<SerachPage> {
  TextEditingController searchUserData = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Bar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchUserData,
              decoration: const InputDecoration(
                  hintText: 'Search Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(23)))),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: const Text(
                  "Serach",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: searchUserData.text)
                    .where('email', isNotEqualTo: widget.userModel.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot serachUser = snapshot.data as QuerySnapshot;
                      if (serachUser.docs.isNotEmpty) {
                        Map<String, dynamic> usermap =
                            serachUser.docs[0].data() as Map<String, dynamic>;
                        UserModel searchedUser = UserModel.fromMap(usermap);
                        return ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatAppRoom()));
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchedUser.profilepic!),
                          ),
                          title: Text(searchedUser.fullname!),
                          subtitle: Text(searchedUser.email!),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        );
                      } else {
                        return const Text("User Not found");
                      }
                    } else if (snapshot.hasError) {
                      return const Text("Error as accored!");
                    } else {
                      return const Text("Result not found!");
                    }
                  } else {
                    return const CircularProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.black,
                    );
                  }
                })
          ],
        ),
      )),
    );
  }
}
