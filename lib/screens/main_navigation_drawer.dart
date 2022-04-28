import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/account_details_screen.dart';
import 'package:swap_shop/screens/forgot_password_screen.dart';
import 'login_screen.dart';

class MainNavigationDrawer extends StatefulWidget {
  const MainNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<MainNavigationDrawer> createState() => _MainNavigationDrawerState();
}

class _MainNavigationDrawerState extends State<MainNavigationDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();

  String? currentImageURL;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
    getImageURL();
  }

  Future getImageURL() async {
    var collection = FirebaseFirestore.instance.collection("users");
    var docSnapshot = await collection.doc(user!.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();
    currentImageURL = data?['ProfilePicture'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        "https://www.iconsdb.com/icons/preview/red/user-xxl.png"),
                    foregroundImage: NetworkImage(currentImageURL.toString()),
                    radius: 80.0,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userModel.name.toString() == "null"
                        ? "Loading.."
                        : userModel.name.toString(),
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userModel.email.toString() == "null"
                        ? "Loading.."
                        : userModel.email.toString(),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  )
                ],
              ))),
      SizedBox(
        height: 80,
      ),
      ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountDetails()));
        },
        leading: Icon(
          Icons.person,
          color: Colors.red,
        ),
        title: Text("Account Details",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400)),
      ),
      SizedBox(
        height: 20,
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.list,
          color: Colors.red,
        ),
        title: Text("Your Listings",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400)),
      ),
      SizedBox(
        height: 20,
      ),
      ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
        },
        leading: Icon(
          Icons.lock,
          color: Colors.red,
        ),
        title: Text("Password Reset",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400)),
      ),
      SizedBox(
        height: 20,
      ),
      ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        leading: Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: Text("Logout",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400)),
      )
    ]);
  }
}
