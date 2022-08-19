import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/pages/admin/markattendance.dart';
import 'package:studentconsole/pages/admin/postassignment.dart';
import 'package:studentconsole/pages/admin/postnotice.dart';
import 'package:studentconsole/pages/attendance.dart';
import 'package:studentconsole/pages/auth/login.dart';
import 'package:studentconsole/pages/auth/register.dart';
import 'package:studentconsole/pages/auth/reset.dart';
import 'package:studentconsole/pages/homepage.dart';
import 'package:studentconsole/pages/notification.dart';
import 'package:studentconsole/pages/editprofile.dart';
import 'package:studentconsole/pages/splashscreen.dart';
import 'flutterfire/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Console',
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      ),
      initialRoute: ('/'),
      routes: {
        '/': (context) => const SplashScreen(),
        '/homepage': (context) => const HomePage(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/reset': (context) => const ResetPassword(),
        '/notice': (context) => const NotificationGet(),
        '/markattendance': (context) => const MarkAttendance(),
        '/attendance': (context) => const Attendance(),
        '/editprofile': (context) => const EditProfile(),
        '/postassignment': (context) => const PostAssignment(),
        '/postnotice': (context) => const PostNotice(),
      },
    );
  }
}
