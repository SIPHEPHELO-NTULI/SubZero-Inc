import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/models/database_manager.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/create_listing.dart';
import 'package:swap_shop/screens/detail_screen.dart';
import 'package:swap_shop/screens/home_screen.dart';

class BrowseListings extends StatefulWidget {
  const BrowseListings({Key? key}) : super(key: key);

  @override
  State<BrowseListings> createState() => _BrowseListingsState();
}



class _BrowseListingsState extends State<BrowseListings> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  UserListingModel userListing = UserListingModel();
  int curr = 2;
  List listings = [];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Items"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: FireStoreDataBase().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            listings = snapshot.data as List;
            return Scaffold(
                body: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    itemCount: listings.length,
                    
                    itemBuilder: (context, index) => Padding(
                      
                          padding: const EdgeInsets.all(6.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.red,
                            elevation: 3.0,
                            
                            child: InkWell(

                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsScreen( 
                                        description: listings[index]['description'],
                                        itemName: listings[index]['itemName'],
                                        productImage: listings[index]['imageURL'],
                                        subCategories: listings[index]['subCatogories'],
                                      )));
                                      
                                    } ,

                              child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(15), // Image border
                                    child: AspectRatio(
                                      aspectRatio: 15 / 9,
                                      child: Image.network(
                                        listings[index]['imageURL'],
                                        fit: BoxFit.fill, // use this
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Container(
                                          child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listings[index]['itemName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(listings[index]['category']),
                                          Icon(Icons.favorite)
                                        ],
                                      )),
                                    ),
                                  
                                ],
                              ),
                             
                            ),
                          ),
                        )));
          }
          return const Center(child: CircularProgressIndicator());
        },
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
            if (curr == 1) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CreateListing()));
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
}
