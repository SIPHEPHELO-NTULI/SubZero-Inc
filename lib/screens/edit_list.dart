import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/home_screen.dart';
import 'package:swap_shop/screens/main_navigation_drawer.dart';
import 'package:swap_shop/screens/user_lists.dart';

import '../models/database_manager.dart';

class EditList extends StatefulWidget {
  final String description;
  final String listingProvince;
  final String listingCity;
  final String itemName;
  final String productImage;
  final String timeStamp;
  final String category;
  final String listingID;
  final List subCategories;
  const EditList(
      {Key? key,
      required this.description,
      required this.listingProvince,
      required this.listingCity,
      required this.itemName,
      required this.productImage,
      required this.timeStamp,
      required this.category,
      required this.listingID,
      required this.subCategories})
      : super(key: key);

  @override
  State<EditList> createState() => _Editlist();
}

class _Editlist extends State<EditList> {
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
  final List<String> subcategories = [];
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  int curr = 1;
  bool visibility_clothe_size = false;
  bool visibility_Expire_date = false;
  final List<String> categorys = [
    'Food',
    'Furniture',
    'Books',
    'Electronics',
    'Clothing',
    'Other'
  ];
  final List<String> clothes_size = ['XS', 'S', 'M', 'L', 'XL'];
  String? selectedCategory;
  String? selectedvalue;
  String? selectedsize;

  String? selected_clothe_size;
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

//snack bar for error/success messages
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
        content: Text(snackText), duration: d, backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final TextEditingController itemNameEditingController =
      new TextEditingController();
  final TextEditingController descriptionEditingController =
      new TextEditingController();

//this is used to get the uid for the logged in user
  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.userModel = UserModel.fromMap(value.data());
      setState(() {
        itemNameEditingController.text = widget.itemName.toString();
        descriptionEditingController.text = widget.description.toString();
        item_Expire_date_EditingController.text =
            widget.subCategories[0].toString();
        selectedvalue = widget.category.toString();
        if (widget.category.toString() == "Food") {
          dateinput.text = widget.subCategories[0].toString();
        }
        if (widget.category.toString() == "Clothing") {
          selectedsize = widget.subCategories[0].toString();
        }

        subcategories.clear();
        if (selectedvalue == "Clothing") {
          visibility_clothe_size = true; // show clothe size dropdown.
          visibility_Expire_date = false; // hide expiring date field
        } else if (selectedvalue == "Food") {
          visibility_Expire_date = true; // show expiring date field.
          visibility_clothe_size = false; //hide clothe size dropdown.
        } else {
          visibility_clothe_size = false;
          visibility_Expire_date = false;
        }
      });
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

  //the following method accepts a string parameter of the image url
  //the listing details are then mapped together using the UserListingModel class
  //and added to the Firebase Database
  postDetailsToFirestore(String imageURl, String listingID) async {
    //calling firestore
    //calling our user listing model
    //sending values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    //class containing users listing details
    //writing values from text fields to objects attributes
    String date_listed = DateFormat("dd, MMM, yyyy").format(DateTime
        .now()); // stores the time of uploading the item on the database.
    userListing.uid = userModel.uid;
    userListing.listingProvince = userModel.province;
    userListing.listingCity = userModel.city;
    userListing.itemName = itemNameEditingController.text;
    if (selectedCategory == null) {
      selectedCategory = widget.category;
    }
    userListing.category = selectedCategory;
    userListing.subCategories = subcategories;

    if (subcategories.isEmpty) {
      subcategories.add(widget.subCategories[0].toString());
      //subcategories.add("N/A");
    }
    userListing.description = descriptionEditingController.text;
    userListing.imageURL = imageURl;
    userListing.listingTime = date_listed;
    userListing.listingID = listingID;

    //sending values to database as map
    await firebaseFirestore
        .collection("Listing")
        .doc(userListing.listingID)
        .update(userListing.toMap());

    //linking listing to the current user
    subcategories.clear();
  }

  //This method uploads the chosen image to Firebase Storage
  //It then extracts the download url of the image
  //Then calls the postDetailsToFirestore method to send the listing
  Future uploadData() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final postID = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("${widget.listingID}/images")
          .child("post_$postID");
      await ref.putFile(_image!);
      downloadURL = await ref.getDownloadURL();
      //upload URL to cloud firestore
      postDetailsToFirestore(downloadURL!, widget.listingID);
    }
  }

  //initialising editiing controllers to store
  //item name, Expiring date and description

  final TextEditingController dateinput = new TextEditingController();

  final TextEditingController item_Expire_date_EditingController =
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

    final Expire_date_Field = Visibility(
        visible: visibility_Expire_date,
        child: TextFormField(
          controller: dateinput, //editing controller of this TextField
          validator: (value) {
            if (value!.isEmpty) {
              return ("Date is not selected");
            }
            return null;
          },
          decoration: InputDecoration(
              icon: Icon(Icons.calendar_today), //icon of text field
              labelText: "Enter Expiration Date" //label text of field
              ),
          readOnly: true, //set it true, so that user will not able to edit text
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(
                    2000), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101));

            if (pickedDate != null) {
              print(
                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);

              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              //you can implement different kind of Date Format here according to your requirement

              setState(() {
                subcategories.add('Expiry Date: ' + formattedDate);
                dateinput.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {
              print("Date is not selected");
            }
          },
        ));

    //Description field
    //validation : must be filled in
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionEditingController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    //Create Button
    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        minWidth: 80,
        onPressed: () {
          if (_image == null) {
            postDetailsToFirestore(widget.productImage, widget.listingID);
          } else {
            uploadData();
          }
          //added navigation and save confirmation
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => YourLists(),
          ));

          Fluttertoast.showToast(
            msg: 'Listing Saved',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
        child: Text(
          "Save",
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }),
        ],
      ),
      drawer: Drawer(
        child: MainNavigationDrawer(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Edit Your Listing Below",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      itemNameField,
                      SizedBox(
                        height: 10,
                      ),
                      //create a dropdown for categorys.
                      DropdownButtonFormField2(
                        decoration: InputDecoration(
                          //Add isDense true and zero Padding.
                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(Icons.category),
                          //Add more decoration as you want here
                          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                        ),
                        isExpanded: true,
                        hint: const Text(
                          'Select Category',
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 60,
                        buttonPadding:
                            const EdgeInsets.only(left: 20, right: 10),
                        dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 255, 98, 87)),
                        items: categorys
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedvalue,
                        validator: (value) {
                          if (value == null) {
                            return '      Please select category.';
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            selectedvalue:
                            val;
                            selectedCategory = val.toString();
                            if (selectedCategory == "Clothing") {
                              visibility_clothe_size =
                                  true; // show clothe size dropdown.
                              visibility_Expire_date =
                                  false; // hide expiring date field
                            } else if (selectedCategory == "Food") {
                              visibility_Expire_date =
                                  true; // show expiring date field.
                              visibility_clothe_size =
                                  false; //hide clothe size dropdown.
                            } else {
                              visibility_clothe_size = false;
                              visibility_Expire_date = false;
                            }
                          });
                        },
                        onSaved: (value) {
                          if (selectedCategory == null) {
                            selectedCategory = widget.category.toString();
                          } else {
                            selectedCategory = value.toString();
                          }
                        },
                        dropdownMaxHeight: 200,
                        dropdownWidth: 200,
                        dropdownElevation: 8,
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(10, 0),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Dropdown for clothes sizes.
                      Visibility(
                        visible: visibility_clothe_size,
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            prefixIcon: Icon(Icons.category),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select Clothe Size',
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding:
                              const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 255, 98, 87)),
                          items: clothes_size
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedsize,
                          validator: (value) {
                            if (value == null) {
                              return '      Please select clothe size.';
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              selectedsize = val as String?;
                              selected_clothe_size = val.toString();
                              subcategories.add(selectedsize!);
                            });
                          },
                          onSaved: (value) {
                            selected_clothe_size = value.toString();
                          },
                          dropdownMaxHeight: 200,
                          dropdownWidth: 200,
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                          offset: const Offset(10, 0),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Expire_date_Field,

                      SizedBox(
                        height: 10,
                      ),

                      descriptionField,

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                          width: 300,
                          height: 260,
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
                              Container(
                                height: 200,
                                child: _image == null
                                    ? Center(
                                        child:
                                            Image.network(widget.productImage))
                                    : Image.file(
                                        _image!,
                                        width: 100,
                                        height: 100,
                                      ),
                              ),
                            ],
                          ))),

                      SizedBox(
                        height: 10,
                      ),

                      saveButton,
                    ],
                  )),
            ),
          ),
        ),
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
