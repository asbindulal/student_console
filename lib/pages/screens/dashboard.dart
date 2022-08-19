import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 40, 10, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard',
                  style: xxlStyle(color: black, fw: FontWeight.w400),
                ),
                IconButton(
                  iconSize: 35,
                  icon: const Icon(LineIcons.bell),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/notice');
                  },
                ),
              ],
            ),
            getAttendanceData(),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Latest Assignment',
                          style: lStyle(
                            color: black,
                            fw: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Latest Notice',
                          style: lStyle(
                            color: black,
                            fw: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/postassignment');
                },
                color: primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        LineIcons.tasks,
                        size: 50,
                        color: white,
                      ),
                      Text(
                        'Assign Assignment',
                        style: lStyle(color: white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/postnotice');
                },
                color: primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        LineIcons.bullhorn,
                        size: 50,
                        color: white,
                      ),
                      Text(
                        'Send Notice',
                        style: lStyle(color: white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAttendanceData() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(
                '/studentconsole/attendance/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
            .where('uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center();
          }
          int totalAttendance = snapshot.data!.docs.length;

          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                      '/studentconsole/attendance/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
                  .where('uid', isEqualTo: user!.uid)
                  .where('status', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return const Text("something is wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center();
                }
                int totalpresent = snapshot.data!.docs.length;

                double getPercent = totalpresent / totalAttendance * 100;
                String getP = getPercent.toStringAsFixed(1);

                return Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Attendance',
                          style: lStyle(
                            color: black,
                            fw: FontWeight.w400,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Card(
                              color: secondaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Present : $totalpresent ',
                                  style: bodyStyle(
                                    color: black,
                                    fw: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Absent : ${totalAttendance - totalpresent} ',
                                  style: bodyStyle(
                                    color: white,
                                    fw: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: black,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$getP %',
                                  style: bodyStyle(
                                    color: white,
                                    fw: FontWeight.w400,
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
              });
        });
  }
}
