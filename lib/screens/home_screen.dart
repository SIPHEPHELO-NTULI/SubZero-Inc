import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  String? itemName, category, description;
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

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

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  Future uploadData() async {
    if (_formKey.currentState!.validate()) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("${loggedInUser.uid}/images")
          .child("post_$postID");
      await ref.putFile(_image!);
      downloadURL = await ref.getDownloadURL();
      //upload URL to cloud firestore
      await firebaseFirestore
          .collection("users")
          .doc(loggedInUser.uid)
          .collection("images")
          .add({'imageDownloadURL': downloadURL}).whenComplete(() =>
              showSnackBar(
                  "Listing Uploaded Successfully", Duration(seconds: 2)));
      await firebaseFirestore
          .collection("users")
          .doc(loggedInUser.uid)
          .collection("images")
          .add({'Item Name': itemNameEditingController.text});
      await firebaseFirestore
          .collection("users")
          .doc(loggedInUser.uid)
          .collection("images")
          .add({'Category': categoryEditingController.text});
      await firebaseFirestore
          .collection("users")
          .doc(loggedInUser.uid)
          .collection("images")
          .add({'Description': descriptionEditingController.text});
    }
  }

  final TextEditingController itemNameEditingController =
      new TextEditingController();
  final TextEditingController categoryEditingController =
      new TextEditingController();
  final TextEditingController descriptionEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //itemName field
    final itemNameField = TextFormField(
      autofocus: false,
      controller: itemNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Item Name Cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        itemNameEditingController.text = value!;
        itemName = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.book),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Item Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Category field
    final categoryField = TextFormField(
      autofocus: false,
      controller: categoryEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Category Cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        categoryEditingController.text = value!;
        category = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.category),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Category",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Description field
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Description Cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        descriptionEditingController.text = value!;
        description = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 80),
          hintText: "Description Of Your Item",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Create Button
    final createButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        minWidth: 80,
        onPressed: () {
          uploadData();
        },
        child: Text(
          "Create",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text(
                  "Create Your Listing Below",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                itemNameField,
                SizedBox(
                  height: 10,
                ),
                categoryField,
                SizedBox(
                  height: 10,
                ),
                descriptionField,
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red)),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  imagePickerMethod();
                                },
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                )),
                            Expanded(
                              child: _image == null
                                  ? const Center(
                                      child: Text("No Image Selected"))
                                  : Image.file(
                                      _image!,
                                      width: 200,
                                      height: 200,
                                    ),
                            ),
                          ],
                        )))),
                SizedBox(
                  height: 10,
                ),
                createButton,
              ],
            )),
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: const Text("My Listing"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
