import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/auth.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? user = auth.currentUser;
  UserModel currentUser = UserModel();

  @override
  void initState() {
    super.initState();
    firestore
        .collection("studentconsole/users/accounts")
        .doc(user!.uid)
        .get()
        .then((value) {
      currentUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
        leading: IconButton(
          onPressed: () {
            signOut(context);
          },
          icon: const Icon(LineIcons.alternateSignOut),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/editprofile');
            },
            icon: const Icon(LineIcons.userEdit),
          ),
        ],
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
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage('${currentUser.avatar}'),
                      ),
                      gap,
                      Text(
                        '${currentUser.fullname}',
                        style: xlStyle(
                          color: black,
                        ),
                      ),
                      Text(
                        '${currentUser.email}',
                        style: bodyStyle(
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              gap,
              ListTile(
                tileColor: white,
                leading: Text(
                  'Batch',
                  style: bodyStyle(
                    color: darkGrey,
                  ),
                ),
                trailing: Text(
                  '${currentUser.batch}',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                tileColor: white,
                leading: Text(
                  'Faculty',
                  style: bodyStyle(
                    color: darkGrey,
                  ),
                ),
                trailing: Text(
                  '${currentUser.faculty}',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                tileColor: white,
                leading: Text(
                  'Semester',
                  style: bodyStyle(
                    color: darkGrey,
                  ),
                ),
                trailing: Text(
                  '${currentUser.semester}',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                tileColor: white,
                leading: Text(
                  'Section',
                  style: bodyStyle(
                    color: darkGrey,
                  ),
                ),
                trailing: Text(
                  '${currentUser.section}',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                tileColor: white,
                leading: Text(
                  'Phone Number',
                  style: bodyStyle(
                    color: darkGrey,
                  ),
                ),
                trailing: Text(
                  '${currentUser.phonenumber}',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                tileColor: white,
                iconColor: black,
                leading: Text(
                  'Attendance',
                  style: bodyStyle(
                    color: darkGrey,
                  ),
                ),
                trailing: const Icon(LineIcons.arrowRight),
                onTap: () async {
                  Navigator.of(context).pushNamed('/attendance');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
