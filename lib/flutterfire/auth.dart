import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

userStatus(BuildContext context) {
  auth.userChanges().listen((User? user) {
    if (user == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }
  });
}

Future login(
  BuildContext context, {
  required email,
  required password,
}) async {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (email == '') {
    newSnackBar(context, title: 'Email feild cannot be empty!');
  } else if (emailValid == false) {
    newSnackBar(context, title: 'Invalid Email Format');
  } else if (password == '') {
    newSnackBar(context, title: 'Password feild cannot be empty!');
  } else {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.of(context).pushReplacementNamed('/homepage'),
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        newSnackBar(context, title: 'User not found!');
      } else if (e.code == 'invalid-email') {
        newSnackBar(context, title: 'Enter a valid email');
      } else if (e.code == 'wrong-password') {
        newSnackBar(context, title: 'Enter correct Password!');
      } else {
        newSnackBar(context, title: e.code);
      }
    }
  }
}

Future register(
  BuildContext context, {
  required password,
  required email,
  required fullname,
  required phonenumber,
  required batch,
  required faculty,
  required section,
  required semester,
  required avatar,
}) async {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (fullname == '') {
    newSnackBar(context, title: 'Name feild cannot be empty!');
  } else if (email == '') {
    newSnackBar(context, title: 'Email feild cannot be empty!');
  } else if (emailValid == false) {
    newSnackBar(context, title: 'Invalid Email Format');
  } else if (phonenumber == '') {
    newSnackBar(context, title: 'Number feild cannot be empty!');
  } else if (password == '') {
    newSnackBar(context, title: 'Password feild cannot be empty!');
  } else {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((data) async {
        newSnackBar(context, title: 'New Account Created!');
        Navigator.of(context).pushReplacementNamed('/homepage');
        var uploaded = await storage
            .ref('useravatar')
            .child(data.user!.uid)
            .putFile(avatar);

        var avatarLink = await uploaded.ref.getDownloadURL();
        UserModel userModel = UserModel();

        userModel.avatar = avatarLink;
        userModel.uid = data.user!.uid;
        userModel.email = email;
        userModel.fullname = fullname;
        userModel.phonenumber = phonenumber;
        userModel.batch = batch;
        userModel.faculty = faculty;
        userModel.section = section;
        userModel.semester = semester;
        userModel.user = 'student';

        await firestore
            .collection("studentconsole/users/accounts")
            .doc(data.user!.uid)
            .set(userModel.toMap());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        newSnackBar(context, title: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        newSnackBar(context,
            title: 'The account already exists for that email.');
      }
    } catch (e) {
      newSnackBar(context, title: '$e');
    }
  }
}

Future resetPassword(BuildContext context, {required String email}) async {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (email == '') {
    newSnackBar(context, title: 'Email feild cannot be empty!');
  } else if (emailValid == false) {
    newSnackBar(context, title: 'Invalid Email Format');
  } else {
    await auth.sendPasswordResetEmail(email: email).then((uid) {
      newSnackBar(context, title: 'Password reset link sent to email.');
      Navigator.of(context).pop();
    }).catchError((e) {
      newSnackBar(context, title: '$e');
    });
  }
}

Future signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut().then(
        (value) => Navigator.of(context).pushReplacementNamed('/login'),
      );
}

Future changeProfile(BuildContext context, {required avatar}) async {
  try {
    await storage
        .ref('useravatar')
        .child(auth.currentUser!.uid)
        .delete()
        .then((value) async {
      var uploaded = await storage
          .ref('useravatar')
          .child(auth.currentUser!.uid)
          .putFile(avatar);
      var avatarLink = await uploaded.ref.getDownloadURL();

      await firestore
          .collection("studentconsole/users/accounts")
          .doc(auth.currentUser!.uid)
          .update({
        'avatar': avatarLink,
      }).then((value) => newSnackBar(context,
              title: 'Profile Picture Changed Sucessfully!'));
    });
  } catch (e) {
    newSnackBar(context, title: '$e');
  }
}

Future changeEmail(BuildContext context, {required email}) async {
  try {
    await auth.currentUser!.updateEmail(email).then((value) async {
      await firestore
          .collection("studentconsole/users/accounts")
          .doc(auth.currentUser!.uid)
          .update({
        'email': email,
      }).then((value) =>
              newSnackBar(context, title: 'Email Changed Sucessfully!'));
    });
  } catch (e) {
    newSnackBar(context, title: '$e');
  }
}

Future changePassword(BuildContext context, {required password}) async {
  try {
    await auth.currentUser!.updatePassword(password).then((value) {
      newSnackBar(context, title: 'Password Changed Sucessfully!');
    });
  } catch (e) {
    newSnackBar(context, title: '$e');
  }
}

Future postAssignment(
  BuildContext context, {
  required String title,
  required String description,
  required file,
  required duedate,
}) async {
  FirebaseFirestore.instance
      .collection("studentconsole/users/accounts")
      .doc(auth.currentUser!.uid)
      .get()
      .then((value) async {
    UserModel currentUser = UserModel.fromMap(value.data());

    var uploaded = await storage.ref('/assignment').child(title).putFile(file);
    var assignmentFileLink = await uploaded.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection(
            '/studentconsole/assignment/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
        .doc()
        .set({
      'title': title,
      'description': description,
      'file': assignmentFileLink,
      'duedate': duedate,
      'name': currentUser.fullname,
    }).then((value) {
      newSnackBar(context, title: 'Assignment Posted');
      Navigator.of(context).pop();
    });
  });
}

Future postNotice(
  BuildContext context, {
  required String title,
  required String description,
  required file,
  required postdate,
}) async {
  FirebaseFirestore.instance
      .collection("studentconsole/users/accounts")
      .doc(auth.currentUser!.uid)
      .get()
      .then((value) async {
    UserModel currentUser = UserModel.fromMap(value.data());

    var uploaded =
        await storage.ref('/notice').child('$title $postdate').putFile(file);
    var noticeFileLink = await uploaded.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection(
            '/studentconsole/notice/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
        .doc()
        .set({
      'title': title,
      'description': description,
      'file': noticeFileLink,
      'postdate': postdate,
      'name': currentUser.fullname,
    }).then((value) {
      newSnackBar(context, title: 'Notice Posted');
      Navigator.of(context).pop();
    });
  });
}
