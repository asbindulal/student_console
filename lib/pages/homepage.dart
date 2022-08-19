import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/pages/screens/assignment.dart';
import 'package:studentconsole/pages/screens/dashboard.dart';
import 'package:studentconsole/pages/screens/discussion.dart';
import 'package:studentconsole/pages/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int screen = 0;

  changeScreen() {
    switch (screen) {
      case 0:
        return const Dashboard();
      case 1:
        return const Assignment();

      case 2:
        return const Discussion();
      case 3:
        return const UserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: changeScreen(),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: primaryColor,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: grey,
            gap: 8,
            activeColor: black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: white,
            color: white,
            textStyle: GoogleFonts.baloo2(
              fontSize: 17,
              color: black,
            ),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.tasks,
                text: 'Assignment',
              ),
              GButton(
                icon: LineIcons.comment,
                text: 'Chat',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
            ],
            selectedIndex: screen,
            onTabChange: (index) {
              setState(() {
                screen = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
