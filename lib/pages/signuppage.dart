// ignore: avoid_web_libraries_in_flutter
// import 'dart:js';

// import 'package:chatapp/pages/completeprofiepage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/models/uihelper.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/completeprofiepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController email = TextEditingController();

  TextEditingController pass = TextEditingController();

  TextEditingController conpass = TextEditingController();

  void checkValue() {
    String emaildata = email.text.trim();
    String password = pass.text.trim();
    String cpassword = conpass.text.trim();
    if (emaildata == "" || password == "" || cpassword == "") {
      // ignore: avoid_print
      UIHelper.showAlertDailog(
          context, 'Incomplete Data', 'Plz fill all the fields');
    } else if (password != cpassword) {
      UIHelper.showAlertDailog(
          context, 'Password Mismatch', 'The password enter do not match!');
    } else {
      signUp(emaildata, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? userCredential;
    UIHelper.showLoadingDailog(context, 'Creating new account...');
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: avoid_print, use_build_context_synchronously
      UIHelper.showAlertDailog(context, 'Error Accoured', e.message.toString());
    }

    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      UserModel newuser =
          UserModel(email: email, uid: uid, profilepic: '', fullname: '');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(newuser.toMap())
          // ignore: avoid_print
          .then((value) {
        // ignore: avoid_print
        print("User Created!");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CompleteProfile(
                      userModel: newuser,
                      firebaseuser: userCredential!.user!,
                    )));
      });
      // ignore: use_build_context_synchronously

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
                  controller: pass,
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
                TextField(
                  controller: conpass,
                  decoration: const InputDecoration(
                    label: Text('Conform Password',
                        style: TextStyle(fontSize: 15)),
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
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      checkValue();
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    child: const Text(
                      "Signup",
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
            "Already have an account?",
            style: TextStyle(fontSize: 18),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18),
              ))
        ],
      ),
    );
  }
}
