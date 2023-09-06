import 'dart:io';
import 'package:chatapp/models/usermodels.dart';
import 'package:chatapp/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel? userModel;

  final User? firebaseuser;
  const CompleteProfile({super.key, this.userModel, this.firebaseuser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? imagefile;
  TextEditingController fullname = TextEditingController();
  void selectImage(ImageSource source) async {
    XFile? pickedimage = await ImagePicker().pickImage(source: source);
    if (pickedimage != null) {
      cropImage(pickedimage);
    }
  }

  void cropImage(XFile file) async {
    File? croppedimages = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedimages != null) {
      setState(() {
        imagefile = croppedimages;
      });
    }
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select photo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  title: const Text('Select photo from gallery'),
                  leading: const Icon(Icons.photo_album),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  title: const Text('Take camera'),
                  leading: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          );
        });
  }

  void checkValue() {
    String fullnameuser = fullname.text.trim();
    if (fullnameuser == '' || imagefile == null) {
      // ignore: avoid_print
      print("Plz Fill Filed");
    } else {
      uploadImage();
    }
  }

  void uploadImage() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("ProfilePicimage")
        .child(widget.userModel!.uid.toString())
        .putFile(imagefile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageurl = await snapshot.ref.getDownloadURL();
    String fullnameuser = fullname.text.trim();

    widget.userModel!.profilepic = imageurl;
    widget.userModel!.fullname = fullnameuser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel!.uid)
        .set(widget.userModel!.toMap());

    // ignore: avoid_print
    print("UploadTask!!");
    fullname.clear();
    imagefile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text("Complete Profile"),
        ),
        body: SafeArea(
            // ignore: avoid_unnecessary_containers
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              CupertinoButton(
                onPressed: () {
                  showPhotoOption();
                },
                child: CircleAvatar(
                  maxRadius: 60,
                  backgroundColor: Colors.blue,
                  backgroundImage:
                      (imagefile != null) ? FileImage(imagefile!) : null,
                  child: (imagefile == null)
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                  controller: fullname,
                  decoration: const InputDecoration(
                    label: Text('Full Name', style: TextStyle(fontSize: 15)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  checkValue();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Myhome(
                              firbaseuser: widget.firebaseuser!,
                              usermodel: widget.userModel!)));
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: const Text(
                  "Signup",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )));
  }
}
