import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentconsole/flutterfire/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? pickedImage;

  Future pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        pickedImage = File(pickedFile!.path);
      });
    } on PlatformException catch (e) {
      newSnackBar(context, title: 'Failed to select image: $e');
    }
  }

  String section = 'B';

  var secItems = [
    'A',
    'B',
    'C',
    'D',
  ];

  String faculty = 'BIT';

  var facItems = [
    'BIT',
    'BBA',
  ];

  String semester = '5th Semester';

  var semItems = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
  ];

  String batch = 'Fall 2019';

  var batchItems = [
    'Fall 2019',
    '2020',
    'Fall 2020',
  ];

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
                      'Create \nAn Account!',
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
                      IconButton(
                        iconSize: 140,
                        icon: CircleAvatar(
                            radius: 70,
                            backgroundImage: pickedImage != null
                                ? FileImage(
                                    pickedImage as File,
                                  )
                                : null,
                            child: pickedImage != null
                                ? null
                                : Text(
                                    'Select \n Profile \n Picture',
                                    textAlign: TextAlign.center,
                                    style: bodyStyle(
                                      color: white,
                                      fw: FontWeight.bold,
                                    ),
                                  )),
                        onPressed: () async {
                          pickImage();
                        },
                      ),
                      gap,
                      nameFormFeild(),
                      gap,
                      emailFormFeild(),
                      gap,
                      phoneFormFeild(),
                      gap,
                      passwordFormFeild(),
                      gap,
                      StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Column(
                            children: [
                              DropdownButton(
                                style: bodyStyle(color: black),
                                value: batch,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: batchItems.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    section = newValue!;
                                  });
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton(
                                    style: bodyStyle(color: black),
                                    value: faculty,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: facItems.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        faculty = newValue!;
                                      });
                                    },
                                  ),
                                  gap,
                                  DropdownButton(
                                    style: bodyStyle(color: black),
                                    value: semester,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: semItems.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        semester = newValue!;
                                      });
                                    },
                                  ),
                                  gap,
                                  DropdownButton(
                                    style: bodyStyle(color: black),
                                    value: section,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: secItems.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        section = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
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
                            if (pickedImage == null) {
                              newSnackBar(context,
                                  title: 'Select a profile picture.');
                            } else {
                              register(
                                context,
                                password: passwordController.text,
                                email: emailController.text,
                                fullname: nameController.text,
                                phonenumber: phoneController.text,
                                batch: batch,
                                faculty: faculty,
                                section: section,
                                semester: semester,
                                avatar: pickedImage,
                              );
                            }
                          },
                          child: Text(
                            'Register',
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

  nameFormFeild() {
    return TextFormField(
      autofocus: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      controller: nameController,
      cursorColor: black,
      style: bodyStyle(color: black),
      decoration: InputDecoration(
        labelStyle: bodyStyle(color: black),
        labelText: 'Name:',
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

  phoneFormFeild() {
    return TextFormField(
      autofocus: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      controller: phoneController,
      cursorColor: black,
      style: bodyStyle(color: black),
      decoration: InputDecoration(
        labelStyle: bodyStyle(color: black),
        labelText: 'Number:',
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
