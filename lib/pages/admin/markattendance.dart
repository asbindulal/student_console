import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  List<String> presentStudents = [];

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

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('/studentconsole/users/accounts')
        .where(
          'faculty',
          isEqualTo: '${currentUser.faculty}',
        )
        .where('batch', isEqualTo: '${currentUser.batch}')
        .where('section', isEqualTo: '${currentUser.section}')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: black,
        ),
        title: Text(
          'Mark Attendance',
          style: xlStyle(color: black),
        ),
      ),
      body: StreamBuilder(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center();
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                var get = snapshot.data!.docChanges[index];

                return InkWell(
                  onTap: () {
                    setState(() {
                      if (presentStudents.contains(get.doc['uid'])) {
                        presentStudents.remove(get.doc['uid']);
                      } else {
                        presentStudents.add(get.doc['uid']);
                      }
                    });

                    setState(() {});
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(
                        get.doc['fullname'],
                        style: bodyStyle(
                          color: black,
                          fw: FontWeight.w500,
                        ),
                      ),
                      trailing: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: presentStudents.contains(get.doc['uid'])
                              ? secondaryColor
                              : primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                              presentStudents.contains(get.doc['uid'])
                                  ? 'Present'
                                  : 'Absent',
                              style: buttonStyle(
                                color: white,
                              )),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: StreamBuilder(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center();
          }

          var index = snapshot.data!.docs.length - 1;

          void attend(int i) {
            var doc = snapshot.data!.docs[i];

            FirebaseFirestore.instance
                .collection(
                    "/studentconsole/attendance/${currentUser.batch}${currentUser.faculty}${currentUser.section}")
                .doc()
                .set({
              'uid': doc['uid'],
              'time': DateTime.now(),
              'status': presentStudents.contains(doc['uid']) ? true : false,
            });
            DateTime l = DateTime.now();
            String localDate = '${l.month}:${l.day}';
            FirebaseFirestore.instance
                .collection("/studentconsole/")
                .doc('attendance')
                .update({
              '${currentUser.batch}${currentUser.faculty}${currentUser.section}':
                  localDate,
            });

            Navigator.of(context).pushReplacementNamed('/homepage');
          }

          return FloatingActionButton(
              backgroundColor: primaryColor,
              child: const Icon(LineIcons.doubleCheck),
              onPressed: () {
                for (int j = 0; j <= index; j++) {
                  attend(j);
                }
                Navigator.of(context).pop();
                newSnackBar(context, title: 'Attendance Marked Sucessfully!');
              });
        },
      ),
    );
  }
}
