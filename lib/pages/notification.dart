import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/modals/user.dart';

class NotificationGet extends StatefulWidget {
  const NotificationGet({Key? key}) : super(key: key);

  @override
  State<NotificationGet> createState() => _NotificationGetState();
}

class _NotificationGetState extends State<NotificationGet> {
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
    Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
        .collection(
            '/studentconsole/notice/${currentUser.batch}${currentUser.faculty}${currentUser.section}')
        .orderBy(
          'postdate',
          descending: true,
        )
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
          'Notice',
          style: xlStyle(color: black),
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

          return Container(
            transformAlignment: Alignment.center,
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              itemBuilder: (_, index) {
                QueryDocumentSnapshot data = snapshot.data!.docs[index];
                Timestamp t = data['postdate'];
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

                return Column(
                  children: [
                    Text(
                      ' ${monthsGet()[month]} $day ${d.year}',
                      style: smallStyle(color: black),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            color: primaryColor,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['title'],
                                    style: lStyle(
                                      color: white,
                                      fw: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['description'],
                              style: bodyStyle(
                                color: black,
                                fw: FontWeight.w500,
                              ),
                            ),
                          ),
                          Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: EdgeInsets.zero,
                            child: Image.network(
                              '${data['file']}',
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
