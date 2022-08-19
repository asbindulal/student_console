import 'package:flutter/material.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        iconTheme: const IconThemeData(
          color: black,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Reset \nYour \nAccount \nPassword!',
                      style: xxlStyle(
                        color: black,
                        fw: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                gap,
                Form(
                  child: Column(
                    children: [
                      emailFormFeild(),
                      gap,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minWidth: double.maxFinite,
                          color: primaryColor,
                          splashColor: black,
                          onPressed: () {
                            resetPassword(context, email: emailController.text);
                          },
                          child: Text(
                            'Reset Password',
                            style: buttonStyle(
                              color: white,
                              fw: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  emailFormFeild() {
    return TextFormField(
      autofocus: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      cursorColor: black,
      style: bodyStyle(color: black),
      decoration: InputDecoration(
        labelStyle: bodyStyle(color: black),
        labelText: 'Email:',
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
