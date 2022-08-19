import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel currentUser = UserModel();
  String? fd;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("studentconsole/users/accounts")
        .doc(user!.uid)
        .get()
        .then((value) {
      currentUser = UserModel.fromMap(value.data());

      FirebaseFirestore.instance
          .collection("studentconsole/")
          .doc('attendance')
          .get()
          .then((doc) {
        fd =
            '${doc.data()!['${currentUser.batch}${currentUser.faculty}${currentUser.section}']}';
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime l = DateTime.now();
    String localDate = '${l.month}:${l.day}'.toString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: black,
        ),
        title: Text(
          'Attendance',
          style: lStyle(color: black),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(
                '/studentconsole/attendance/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
            .orderBy('time', descending: true)
            .where("uid", isEqualTo: currentUser.uid)
            .limit(50)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              QueryDocumentSnapshot data = snapshot.data!.docs[index];
              var isPresent = data['status'];
              Timestamp t = data['time'];
              DateTime dateTime = t.toDate();
              int m = dateTime.month;
              int d = dateTime.day;

              Map<int, String> monthsGet() {
                return {
                  1: 'Jan',
                  2: 'Feb',
                  3: 'March',
                  4: 'April',
                  5: 'May',
                  6: 'June',
                  7: 'July',
                  8: 'Aug',
                  9: 'Sep',
                  10: 'Oct',
                  11: 'Nov',
                  12: 'Dec',
                };
              }

              return Container(
                margin: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                child: Card(
                  color: isPresent ? secondaryColor : primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${monthsGet()[m]} $d',
                          style: bodyStyle(
                            color: isPresent ? black : white,
                          ),
                        ),
                        Text(
                          isPresent ? 'Present' : 'Absent',
                          style: bodyStyle(
                            color: isPresent ? black : white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: currentUser.user == 'admin'
            ? FloatingActionButton(
                onPressed: fd != localDate
                    ? () {
                        Navigator.of(context).pushNamed('/markattendance');
                      }
                    : () {
                        newSnackBar(context,
                            title: 'Attendance Already Marked For Today!');
                      },
                backgroundColor: primaryColor,
                child: const Icon(
                  LineIcons.plus,
                ),
              )
            : null,
      ),
    );
  }
}
