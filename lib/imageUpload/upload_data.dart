import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadData extends StatefulWidget {
  const UploadData({Key? key}) : super(key: key);

  @override
  State<UploadData> createState() => _UploadDataState();
}

final imagePicker = ImagePicker();

class _UploadDataState extends State<UploadData> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Upload Image",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                child: imageFile == null
                    ? ElevatedButton(
                        onPressed: () {
                          _showDialog();
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ))
                    : Image.file(
                        imageFile!,
                        width: 400,
                        height: 400,
                      ),
              )
            ]),
      ),
    );
  }

  Future<void> _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text("Select Your Upload Option"),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                GestureDetector(
                  child: Text("Gallary"),
                  onTap: () {
                    openGallary();
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    openCamera();
                  },
                )
              ]),
            ),
          );
        });
  }

  Future<void> openGallary() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = pick as File;
    });
  }

  Future<void> openCamera() async {
    final pick = await imagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = pick as File;
    });
  }
}
