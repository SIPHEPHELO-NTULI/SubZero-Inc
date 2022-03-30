import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//image picker for picking image
//firebase storage for uploading image to firebase
//cloud firestore for saving url for uploading to our application

class ImageUpload extends StatefulWidget {
  //create folder for signed in user

  String? userId;
  ImageUpload({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  //initialization code

  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

//image picker
  Future imagePickerMethod() async {
    //pick the file
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        //showing snackbar with error
        showSnackBar("No File Selected", Duration(seconds: 2));
      }
    });
  }

//uploading file to firebase storage
//adding downloaded url to cloud firestore

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget.userId}/images")
        .child("post_$postID");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();

    //upload URL to cloud firestore
    await firebaseFirestore
        .collection("users")
        .doc(widget.userId)
        .collection("images")
        .add({'downloadURL': downloadURL}).whenComplete(() =>
            showSnackBar("Image Uploaded Successfully", Duration(seconds: 2)));
    ;
  }

//snackbar : error displays
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Upload")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 550,
              width: double.infinity,
              child: Column(
                children: [
                  const Text("Upload Image"),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                          width: 350,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red)),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _image == null
                                    ? const Center(
                                        child: Text("No Image Selected"))
                                    : Image.file(_image!),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    imagePickerMethod();
                                  },
                                  child: Text("Select Image")),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_image != null) {
                                      uploadImage();
                                    } else {
                                      showSnackBar("No Image Selected",
                                          Duration(seconds: 2));
                                    }
                                  },
                                  child: Text("Upload Image")),
                            ],
                          ))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
