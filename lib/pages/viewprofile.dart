import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/auth.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

// ignore: must_be_immutable
class ViewProfile extends StatefulWidget {
  String uid;

  ViewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  UserModel viewedUser = UserModel();

  @override
  void initState() {
    super.initState();
    firestore
        .collection("studentconsole/users/accounts")
        .doc(widget.uid)
        .get()
        .then((value) {
      viewedUser = UserModel.fromMap(value.data());
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
                        backgroundImage: NetworkImage('${viewedUser.avatar}'),
                      ),
                      gap,
                      Text(
                        '${viewedUser.fullname}',
                        style: xlStyle(
                          color: black,
                        ),
                      ),
                      Text(
                        '${viewedUser.email}',
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
                  '${viewedUser.batch}',
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
                  '${viewedUser.faculty}',
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
                  '${viewedUser.semester}',
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
                  '${viewedUser.section}',
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
                  '${viewedUser.phonenumber}',
                  style: bodyStyle(
                    color: black,
                  ),
                ),
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
}
