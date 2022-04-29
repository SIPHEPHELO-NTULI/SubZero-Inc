import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swap_shop/screens/main_navigation_drawer.dart';
import 'home_screen.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  var buttonText = 'Save';

  /// Variables to store country state city data in onChanged method.
  String? countryValue;
  String? provinceValue;
  String? cityValue;

  //form key for validation of the form
  final _formKey = GlobalKey<FormState>();
  String? currentImageURL;
  File? _image;
  final imagePicker = ImagePicker();
  String? imageURL;
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
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //editing controllers
  //To control the text boxes for:
  // Name, Surname,Username,
  //Email, Suburb & City
  List details = [];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {});
      nameEditingController.text = userModel.name.toString();
      surnameEditingController.text = userModel.surname.toString();
      usernameEditingController.text = userModel.username.toString();
      emailEditingController.text = userModel.email.toString();
    });
    getImageURL();
  }

  postDetailsToFirestore() async {
    //calling firestore
    //calling our user listing model
    //sending values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    //class containing users listing details

    //writing values from text fields to objects attributes
    userModel.name = nameEditingController.text;
    userModel.surname = surnameEditingController.text;
    userModel.username = usernameEditingController.text;
    userModel.email = emailEditingController.text;
    userModel.province = provinceValue;
    userModel.city = cityValue;

    //sending values to database as map
    await firebaseFirestore
        .collection("Users")
        .doc(userModel.uid)
        .update(userModel.toMap())
        .whenComplete(() =>
            showSnackBar("Details Saved Successfully", Duration(seconds: 2)));
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
          .child("${userModel.uid}/images/profilePicture")
          .child("profileImage");
      await ref.putFile(_image!);
      imageURL = await ref.getDownloadURL();
      //upload URL to cloud firestore
      postDetailsToFirestore();

      await firebaseFirestore
          .collection("Users")
          .doc(userModel.uid)
          .update({"ProfilePicture": imageURL}).whenComplete(() =>
              showSnackBar("Details Saved Successfully", Duration(seconds: 2)));
    }
  }

  Future getImageURL() async {
    var collection = FirebaseFirestore.instance.collection("Users");
    var docSnapshot = await collection.doc(user!.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();
    currentImageURL = data?['ProfilePicture'];
    currentImageURL ??=
        "https://www.iconsdb.com/icons/preview/red/user-xxl.png";
  }

  final TextEditingController nameEditingController =
      new TextEditingController();
  final TextEditingController surnameEditingController =
      new TextEditingController();
  final TextEditingController usernameEditingController =
      new TextEditingController();
  final TextEditingController emailEditingController =
      new TextEditingController();
  final TextEditingController suburbEditingController =
      new TextEditingController();
  final TextEditingController cityEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Name field
    //validation : must be filled in
    //validation : must be 3 Characters Minimum
    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Name Cannot be Empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Name (3 Characters Min)");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Surname field
    //validation : must be filled in
    //validation : must be 3 Characters Minimum
    final surnameField = TextFormField(
      autofocus: false,
      controller: surnameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Surname Cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        surnameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Username field
    //validation : must be filled in
    final usernameField = TextFormField(
      autofocus: false,
      controller: usernameEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Username Cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        usernameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Email field
    //validation : must be filled in
    //validation : must be valid Email
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Sign Up Button
    //Calls SignUp Method with email and password
    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (countryValue == null ||
              provinceValue == null ||
              cityValue == null) {
            showSnackBar(" Province & City Required", Duration(seconds: 3));
          } else {
            if (_image == null) {
              postDetailsToFirestore();
              showSnackBar("Loading...", Duration(seconds: 5));
            } else {
              uploadData();
              showSnackBar("Loading...", Duration(seconds: 5));
            }
          }
        },
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
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
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      imageProfile(),
                      SizedBox(
                        height: 10,
                      ),
                      nameField,
                      SizedBox(
                        height: 10,
                      ),
                      surnameField,
                      SizedBox(
                        height: 10,
                      ),
                      usernameField,
                      SizedBox(
                        height: 10,
                      ),
                      emailField,
                      SizedBox(
                        height: 10,
                      ),

                      ///Adding CSC Picker Widget in app
                      CSCPicker(
                        ///Enable disable state dropdown [OPTIONAL PARAMETER]
                        showStates: true,

                        /// Enable disable city drop down [OPTIONAL PARAMETER]
                        showCities: true,

                        ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                        flagState: CountryFlag.ENABLE,

                        ///placeholders for dropdown search field
                        stateSearchPlaceholder: "province",
                        citySearchPlaceholder: "city",

                        ///labels for dropdown
                        stateDropdownLabel: "Province",
                        cityDropdownLabel: "City",

                        ///Default Country
                        defaultCountry: DefaultCountry.South_Africa,

                        ///Disable country dropdown (Note: use it with default country)
                        disableCountry: true,

                        ///triggers once country selected in dropdown
                        onCountryChanged: (value) {
                          setState(() {
                            ///store value in country variable
                            countryValue = value;
                          });
                        },

                        ///triggers once state selected in dropdown
                        onStateChanged: (value) {
                          setState(() {
                            ///store value in state variable
                            provinceValue = value;
                          });
                        },

                        ///triggers once city selected in dropdown
                        onCityChanged: (value) {
                          setState(() {
                            ///store value in city variable
                            cityValue = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      saveButton,
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 80.0,
            backgroundImage: NetworkImage(currentImageURL.toString()),
            child: CircleAvatar(
              backgroundColor: _image == null ? Colors.transparent : Colors.red,
              radius: 79,
              foregroundImage: _image == null ? null : FileImage(_image!),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 5.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.red,
                size: 35.0,
              ),
            ),
          )
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
