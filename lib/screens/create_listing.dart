import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/browse_listings.dart';
import 'package:swap_shop/screens/home_screen.dart';
import 'package:swap_shop/screens/main_navigation_drawer.dart';

class CreateListing extends StatefulWidget {
  CreateListing({Key? key}) : super(key: key);

  @override
  State<CreateListing> createState() => _CreateListing();
}

class _CreateListing extends State<CreateListing> {
  //Variables:
  //user: this is used to get the  uid of the logged in user
  //userListing : set the attributes of the listing
  //formKey: used for validation of form
  //image: hold the image selected and file path
  // imagePicker: used to pick image from gallery
  //downloadURL: used to extract the url when image is uploaded
  // curr: keeps track of navigation
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  UserListingModel userListing = UserListingModel();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  int curr = 1;

  Future imagePickerMethod() async {
    //pick the image file from users local gallery
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    //display their selected image in the container
    //validate: if no image selected, and error is displayed
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        //showing snackbar with error
        showSnackBar("No File Selected", Duration(seconds: 2));
      }
    });
  }

  Future takePhoto(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(
      source: source,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        //showing snackbar with error
        showSnackBar("No File Selected", Duration(seconds: 2));
      }
    });
  }

//snack bar for error/success messages
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//this is used to get the uid for the logged in user
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  //the following method accepts a string parameter of the image url
  //the listing details are then mapped together using the UserListingModel class
  //and added to the Firebase Database
  postDetailsToFirestore(String imageURl) async {
    //calling firestore
    //calling our user listing model
    //sending values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String listingID =
        FirebaseFirestore.instance.collection("Listings").doc().id;
    //class containing users listing details

    //writing values from text fields to objects attributes
    userListing.uid = userModel.uid;
    userListing.itemName = itemNameEditingController.text;
    userListing.category = categoryEditingController.text;
    userListing.description = descriptionEditingController.text;
    userListing.imageURL = imageURl;
    userListing.listingID = listingID;

    //sending values to database as map
    await firebaseFirestore
        .collection("Listings")
        .doc(userListing.listingID)
        .set(userListing.toMap());

    //linking listing to the current user
    await firebaseFirestore
        .collection("users")
        .doc(userListing.uid)
        .collection("Listings")
        .add({'listingID': listingID}).whenComplete(() => showSnackBar(
            "Listing Uploaded Successfully", Duration(seconds: 2)));
  }

  //This method uploads the chosen image to Firebase Storage
  //It then extracts the download url of the image
  //Then calls the postDetailsToFirestore method to send the listing
  Future uploadData() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("${userListing.uid}/images")
          .child("post_$postID");
      await ref.putFile(_image!);
      downloadURL = await ref.getDownloadURL();
      //upload URL to cloud firestore
      postDetailsToFirestore(downloadURL!);
    }
  }

  //initialising editiing controllers to store
  //item name, category and description
  final TextEditingController itemNameEditingController =
      new TextEditingController();
  final TextEditingController categoryEditingController =
      new TextEditingController();
  final TextEditingController descriptionEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //ItemName field
    //validation : must be filled in
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
    //validation : must be filled in
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
    //validation : must be filled in
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
      appBar: AppBar(
        title: const Text("My Listing"),
      ),
      drawer: Drawer(
        child: MainNavigationDrawer(),
      ),
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
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()),
                                  );
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curr,
        onTap: (index) {
          setState(() {
            curr = index;
            if (curr == 0) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
            if (curr == 2) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BrowseListings()));
            }
          });
        },
        items: [
          BottomNavigationBarItem(
              //index 0
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              //index 1
              icon: Icon(Icons.add),
              label: 'Create',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              //index 2
              icon: Icon(Icons.shopping_basket),
              label: 'Browse',
              backgroundColor: Colors.red),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Picture",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              SizedBox(
                width: 30,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }
}
