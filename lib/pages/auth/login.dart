import 'package:flutter/material.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                  width: double.infinity,
                  child: Text(
                    'Hello \nThere!',
                    style: xxlStyle(
                      color: black,
                      fw: FontWeight.w500,
                    ),
                  ),
                ),
                Form(
                  child: Column(
                    children: [
                      emailFormFeild(),
                      gap,
                      passwordFormFeild(),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/reset');
                            },
                            child: Text(
                              'Forgot Password?',
                              style: bodyStyle(
                                color: black,
                                fw: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      gap,
                      Center(
                        child: Padding(
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
                              login(
                                context,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            },
                            child: Text(
                              'Login',
                              style: buttonStyle(
                                color: white,
                                fw: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                gap,
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: MaterialButton(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                        width: 2,
                        color: black,
                      ),
                    ),
                    minWidth: double.maxFinite,
                    color: white,
                    splashColor: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: Text(
                      'Register',
                      style: buttonStyle(
                        color: black,
                        fw: FontWeight.w500,
                      ),
                    ),
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

  passwordFormFeild() {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      controller: passwordController,
      cursorColor: black,
      style: bodyStyle(color: black),
      decoration: InputDecoration(
        labelStyle: bodyStyle(color: black),
        labelText: 'Password:',
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
