import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
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
    Stream<QuerySnapshot> assignmentStream = FirebaseFirestore.instance
        .collection(
            '/studentconsole/assignment/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
        centerTitle: true,
        title: Text(
          '${currentUser.batch} ${currentUser.faculty} ${currentUser.section}',
          style: lStyle(
            color: black,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: assignmentStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              QueryDocumentSnapshot data = snapshot.data!.docs[index];
              Timestamp t = data['duedate'];
              DateTime d = t.toDate();

              int month = d.month;
              int day = d.day;
              int year = d.year;

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

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ShowAssignment(
                              title: data['title'],
                              description: data['description'],
                              file: data['file'],
                            )),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data['title']}',
                          style: lStyle(
                            color: black,
                          ),
                        ),
                        Text(
                          'By : ${data['name']}',
                          style: bodyStyle(
                            color: black,
                          ),
                        ),
                        Text(
                          'Due Date :${monthsGet()[month]} $day $year',
                          style: bodyStyle(
                            color: black,
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
    );
  }
}

// ignore: must_be_immutable
class ShowAssignment extends StatelessWidget {
  ShowAssignment({
    Key? key,
    required this.title,
    required this.description,
    required this.file,
  }) : super(key: key);

  String? title;
  String? description;
  String? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Assignment Details',
          style: lStyle(
            color: black,
          ),
        ),
        iconTheme: const IconThemeData(color: black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Card(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title!,
                      style: lStyle(
                        color: black,
                      ),
                    ),
                    Text(
                      description!,
                      style: bodyStyle(
                        color: black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewPdf(
                                    pdfLink: file!,
                                    title: title!,
                                  )));
                        },
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'View Assignment',
                            style: bodyStyle(color: white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ViewPdf extends StatelessWidget {
  String pdfLink;
  String title;
  ViewPdf({
    super.key,
    required this.pdfLink,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: black,
        ),
        title: Text(
          title,
          style: lStyle(color: black),
        ),
      ),
      body: const PDF().cachedFromUrl(
        pdfLink,
        placeholder: (progress) => Center(
          // child: Text('$progress %'),
          child: CircularProgressIndicator(
            semanticsValue: '$progress %',
            color: primaryColor,
          ),
        ),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
