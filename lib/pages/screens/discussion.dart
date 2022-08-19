import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/pages/viewprofile.dart';
import 'package:studentconsole/flutterfire/auth.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

class Discussion extends StatefulWidget {
  const Discussion({Key? key}) : super(key: key);

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
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

  final TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MessageShow(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextFormField(
                    controller: message,
                    autofocus: false,
                    cursorColor: black,
                    style: bodyStyle(color: black),
                    decoration: InputDecoration(
                      hintText: 'Message',
                      fillColor: white,
                      labelStyle: bodyStyle(color: black),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (message.text.isNotEmpty) {
                  firestore
                      .collection(
                          '/studentconsole/messages/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
                      .doc()
                      .set({
                    'message': message.text.trim(),
                    'time': DateTime.now(),
                    'notice': false,
                    'avatar': currentUser.avatar,
                    'fullname': currentUser.fullname,
                    'uid': currentUser.uid,
                  });

                  message.clear();
                }
              },
              icon: const Icon(
                LineIcons.paperPlane,
                color: primaryColor,
                size: 29,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageShow extends StatefulWidget {
  const MessageShow({Key? key}) : super(key: key);

  @override
  State<MessageShow> createState() => _MessageShowState();
}

class _MessageShowState extends State<MessageShow> {
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
    Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
        .collection(
            '/studentconsole/messages/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
        .orderBy(
          'time',
          descending: true,
        )
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
        centerTitle: true,
        title: Text(
          '${currentUser.batch} ${currentUser.faculty} ${currentUser.section}',
          style: bodyStyle(
            color: black,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: messageStream,
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
            reverse: true,
            itemBuilder: (_, index) {
              QueryDocumentSnapshot data = snapshot.data!.docs[index];
              Timestamp t = data['time'];
              DateTime d = t.toDate();

              int month = d.month;
              int day = d.day;

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
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      '${d.year} ${monthsGet()[month]} $day',
                      style: smallStyle(color: black),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment:
                          data['fullname'] == currentUser.fullname
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        data['fullname'] != currentUser.fullname
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      data['fullname'],
                                      style: smallStyle(
                                          color: black, fw: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ViewProfile(
                                                    uid: data['uid'],
                                                  )),
                                        );
                                      },
                                      icon: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            NetworkImage(data['avatar']),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 1.45,
                          ),
                          child: Card(
                            color: data['fullname'] == currentUser.fullname
                                ? primaryColor
                                : white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['message'],
                                style: mediumStyle(
                                    color:
                                        data['fullname'] == currentUser.fullname
                                            ? white
                                            : black,
                                    fw: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
