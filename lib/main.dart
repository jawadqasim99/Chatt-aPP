import 'package:chatapp/models/usermodelhelper.dart';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chatapp/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? curentuser = FirebaseAuth.instance.currentUser;

  if (curentuser != null) {
    UserModel? theusermodel =
        await FireBaseHelper.getUserModelId(curentuser.uid);
    runApp(MyLogedIn(firebaseuser: curentuser, userModel: theusermodel!));
    // runApp(const LogInPage());
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LogInPage());
  }
}

class MyLogedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseuser;
  const MyLogedIn(
      {super.key, required this.firebaseuser, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Myhome(firbaseuser: firebaseuser, usermodel: userModel));
  }
}
