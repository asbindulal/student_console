import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:studentconsole/components/constants.dart';
import 'package:studentconsole/flutterfire/auth.dart';

class PostNotice extends StatefulWidget {
  const PostNotice({Key? key}) : super(key: key);

  @override
  State<PostNotice> createState() => _PostNoticeState();
}

class _PostNoticeState extends State<PostNotice> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  File? fileBytes;
  DateTime? pickedDate;
  String fileName = 'Select a file';
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
        centerTitle: true,
        title: Text(
          'Post Notice',
          style: lStyle(
            color: black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Form(
              child: Column(
            children: [
              TextFormField(
                autofocus: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                controller: titleController,
                cursorColor: black,
                style: bodyStyle(color: black),
                decoration: InputDecoration(
                  labelStyle: bodyStyle(color: black),
                  labelText: 'title',
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
              ),
              gap,
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.newline,
                controller: descController,
                cursorColor: black,
                style: bodyStyle(color: black),
                minLines: 5,
                maxLength: 1000,
                maxLines: 10,
                decoration: InputDecoration(
                  labelStyle: bodyStyle(color: black),
                  labelText: 'Description',
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
              ),
              gap,
              Text(
                fileName,
                style: bodyStyle(
                  color: black,
                  fw: FontWeight.w500,
                ),
              ),
              gap,
              !selected
                  ? MaterialButton(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: black,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      minWidth: double.maxFinite,
                      color: white,
                      splashColor: black,
                      onPressed: () {
                        selectFile();
                      },
                      child: Text(
                        'Notice File',
                        style: buttonStyle(
                          color: black,
                          fw: FontWeight.w500,
                        ),
                      ),
                    )
                  : Container(),
              gap,
              MaterialButton(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minWidth: double.maxFinite,
                color: primaryColor,
                splashColor: black,
                onPressed: () {
                  postNotice(
                    context,
                    title: titleController.text,
                    description: descController.text,
                    file: fileBytes,
                    postdate: DateTime.now(),
                  );
                },
                child: Text(
                  'Post Notice',
                  style: buttonStyle(
                    color: white,
                    fw: FontWeight.w500,
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      fileBytes = File('${result.files.first.path}');
      fileName = result.files.first.name;
      selected = true;
      setState(() {});
    }
  }
}
