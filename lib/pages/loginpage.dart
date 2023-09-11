import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/signuppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void checkvalue() {
    String eamilvalue = email.text.trim();
    String pass = password.text.trim();
    if (eamilvalue == '' || pass == '') {
      // ignore: avoid_print
      print("Plz Fill Filed!");
    } else {
      logIn(eamilvalue, pass);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.message.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // ignore: unused_local_variable
      UserModel userModel =
          UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      // ignore: avoid_print
      print("Login Successfully!!");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Myhome(usermodel: userModel, firbaseuser: credential!.user!);
      }));
      // ignore: avoid_print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 320,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Chat App",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      label: Text('Email', style: TextStyle(fontSize: 15)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: password,
                  decoration: const InputDecoration(
                    label: Text('Password', style: TextStyle(fontSize: 15)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      checkvalue();
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Do not have an account?",
            style: TextStyle(fontSize: 18),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ));
              },
              child: const Text(
                "SignUp",
                style: TextStyle(fontSize: 18),
              ))
        ],
      ),
    );
  }
}
