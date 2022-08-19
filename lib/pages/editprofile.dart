import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/auth.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel currentUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("studentconsole/users/accounts")
        .doc(user!.uid)
        .get()
        .then((value) {
      currentUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  ImagePicker picker = ImagePicker();
  File? pickedImage;

  bool updateProfile = false;

  Future pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        pickedImage = File(pickedFile!.path);

        updateProfile = true;
      });
    } on PlatformException catch (e) {
      newSnackBar(context, title: 'Failed to select image: $e');
    }
  }

  TextEditingController aFeildController = TextEditingController();
  TextEditingController bFeildController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: lStyle(
            color: black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      updateProfile
                          ? CircleAvatar(
                              radius: 70,
                              backgroundImage: FileImage(pickedImage!),
                            )
                          : CircleAvatar(
                              radius: 70,
                              backgroundColor: primaryColor,
                              child: TextButton(
                                onPressed: () {
                                  pickImage();
                                },
                                child: updateProfile
                                    ? const Text('')
                                    : Text(
                                        'Change Profile \nPicture',
                                        style: bodyStyle(
                                          color: white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
              gap,
              updateProfile
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: MaterialButton(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minWidth: double.maxFinite,
                        color: primaryColor,
                        splashColor: black,
                        onPressed: () {
                          if (pickedImage == null) {
                            newSnackBar(context,
                                title: 'Select a profile picture.');
                          } else {
                            changeProfile(context, avatar: pickedImage);
                          }
                        },
                        child: Text(
                          'Change',
                          style: buttonStyle(
                            color: white,
                            fw: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              gap,
              ListTile(
                tileColor: white,
                leading: Text(
                  'Edit Email',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
                trailing: const Icon(LineIcons.arrowRight),
                onTap: () {
                  showNewDialog(
                      a: 'Email:',
                      b: 'Confirm Email',
                      title: 'Change Email',
                      onPressed: () {
                        if (aFeildController.text == bFeildController.text) {
                          if (aFeildController.text.isEmpty &&
                              bFeildController.text.isEmpty) {
                            newSnackBar(context, title: 'Email Feild Empty!');
                          } else {
                            changeEmail(context, email: aFeildController.text);
                          }
                        } else {
                          newSnackBar(context, title: 'Email does not match!');
                        }

                        Navigator.of(context).pop();
                      });
                },
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                tileColor: white,
                leading: Text(
                  'Change Password',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
                trailing: const Icon(LineIcons.arrowRight),
                onTap: () {
                  showNewDialog(
                      a: 'Password:',
                      b: 'Confirm Password',
                      title: 'Change Password',
                      onPressed: () {
                        if (aFeildController.text == bFeildController.text) {
                          if (aFeildController.text.isEmpty &&
                              bFeildController.text.isEmpty) {
                            newSnackBar(context,
                                title: 'Password Feild Empty!');
                          } else {
                            changePassword(context,
                                password: aFeildController.text);
                          }
                        } else {
                          newSnackBar(context,
                              title: 'Password does not match!');
                        }

                        Navigator.of(context).pop();
                      });
                },
              ),
              const SizedBox(
                height: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showNewDialog({
    required String a,
    required String b,
    required String title,
    required onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width / 1.3,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: lStyle(
                    color: black,
                  ),
                ),
                gap,
                TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: aFeildController,
                  cursorColor: black,
                  style: bodyStyle(color: black),
                  decoration: InputDecoration(
                    labelStyle: bodyStyle(color: black),
                    labelText: a,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                gap,
                TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: bFeildController,
                  cursorColor: black,
                  style: bodyStyle(color: black),
                  decoration: InputDecoration(
                    labelStyle: bodyStyle(color: black),
                    labelText: b,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: MaterialButton(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minWidth: double.maxFinite,
                        color: primaryColor,
                        splashColor: black,
                        onPressed: onPressed,
                        child: Text(
                          'Change',
                          style: buttonStyle(
                            color: white,
                            fw: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    gap,
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: MaterialButton(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minWidth: double.maxFinite,
                        color: black,
                        splashColor: black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Back',
                          style: buttonStyle(
                            color: white,
                            fw: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
