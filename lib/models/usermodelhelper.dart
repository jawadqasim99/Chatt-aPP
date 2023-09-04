import 'package:chatapp/models/usermodels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseHelper {
  static Future<UserModel?> getUserModelId(String uid) async {
    UserModel? usermodel;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (snapshot.data() != null) {
      usermodel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return usermodel;
  }
}
