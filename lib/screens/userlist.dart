import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/DatabaseManager/DatabaseManager.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/home_screen.dart';
import 'package:swap_shop/screens/registration_screen.dart';
import 'package:swap_shop/screens/login_screen.dart';

//void main() => runApp(UserListScreen());


class UserListScreen extends StatefulWidget {
  
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<String> values =['assets/ps4.jpg','assets/download.jpg','assets/jacket.jpg','assets/phne.jpg','assets/pots.jpg','assets/shoe.jpg','assets/jacket.jpg','assets/phne.jpg','assets/pots.jpg','assets/shoe.jpg','assets/ps4.jpg','assets/download.jpg'];

  List userProfilesList = [];
  String userID = "";
 @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDatabaseList();
  }

  fetchUserInfo() async{
    User? getUser = FirebaseAuth.instance.currentUser;
    UserModel userID = UserModel();
  }

  fetchDatabaseList() async{ 
  dynamic resultant = await DatabaseManager().getUsersList();
  if (resultant == null){
    print('unable to review');
  } else{
    setState(() {
      userProfilesList = resultant;
    });
  }
 }
  updateData(String username, String city, String email,String name, String userID) async{
    await DatabaseManager().updateUserList(username, city, email, name, userID);
    fetchDatabaseList();
  }

  var map1;
  
 @override
 
 Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SWAPSHOP'),

          backgroundColor: Colors.red,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,

      ),
      itemCount: userProfilesList.length,
      itemBuilder: (context,index)=> Padding(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.redAccent,
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15), // Image border
                child: AspectRatio(
                  aspectRatio: 15/ 9,
                  child: Image(
                    image: AssetImage(values[index]),

                    
                    fit: BoxFit.fill, // use this
                  ),
                ),
              ),
              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userProfilesList[index]["username"],style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(userProfilesList[index]["name"]),
                      Icon(Icons.favorite)
                    ],
                  )
              )
            ],
          ),
        ),
      )
      )
      ),
    );
  }

  /*Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 120, 3),
          automaticallyImplyLeading: false,
        
        ),
        
      
        body: Container(
            child: ListView.builder(
                itemCount: userProfilesList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(userProfilesList[index]['username']),
                      subtitle: Text(userProfilesList[index]['name']),
                      leading: CircleAvatar(
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                        ),
                      ),
                      trailing: Text(userProfilesList[index]['city']),
                    ),
                  );
                }))
        );
  }*/

}

