import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/loginpage.dart';
import 'package:chatapp/pages/serachpasge.dart';
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
          'Home',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(child: Container()),
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
