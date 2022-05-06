import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/models/database_manager.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/create_listing.dart';
import 'package:swap_shop/screens/home_screen.dart';
import 'package:swap_shop/screens/main_navigation_drawer.dart';
import 'package:csc_picker/csc_picker.dart';

import 'details_screen.dart';

class BrowseListings extends StatefulWidget {
  const BrowseListings({Key? key}) : super(key: key);

  @override
  State<BrowseListings> createState() => _BrowseListingsState();
}

class _BrowseListingsState extends State<BrowseListings> {
  /// Variables to store country state city data in onChanged method.
  String? countryValue;
  String? provinceValue;
  String? cityValue;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  UserListingModel userListing = UserListingModel();
  int curr = 2;
  List listings = [];
  String? selectedCategory = 'None';
  List byFilter = [];
  var categoryList = [
    'None',
    'Food',
    'Furniture',
    'Books',
    'Electronics',
    'Clothing',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        title: const Text("Available Items"),
      ),
      drawer: Drawer(
        child: MainNavigationDrawer(),
      ),
      endDrawer: Drawer(child: filterDrawer()),
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
            byFilter.clear();

            //No Filters Chosen
            if (selectedCategory == 'None' &&
                provinceValue == null &&
                cityValue == null) {
              byFilter = listings;
            }
            //Filter By Province & City
            else if (selectedCategory == 'None' &&
                provinceValue != null &&
                cityValue != null) {
              for (int i = 0; i < listings.length; i++) {
                if (listings[i]['listingProvince'] == provinceValue &&
                    listings[i]['listingCity'] == cityValue) {
                  byFilter.add(listings[i]);
                }
              }
            }
            //filter by Province Only
            else if (selectedCategory == 'None' &&
                provinceValue != null &&
                cityValue == null) {
              for (int i = 0; i < listings.length; i++) {
                if (listings[i]['listingProvince'] == provinceValue) {
                  byFilter.add(listings[i]);
                }
              }
            }
            //filter by Category Only
            else if (selectedCategory != 'None' &&
                provinceValue == null &&
                cityValue == null) {
              for (int i = 0; i < listings.length; i++) {
                if (listings[i]['category'] == selectedCategory) {
                  byFilter.add(listings[i]);
                }
              }
            }

            //filter by Category & Province Only
            else if (selectedCategory != 'None' &&
                provinceValue != null &&
                cityValue == null) {
              for (int i = 0; i < listings.length; i++) {
                if (listings[i]['category'] == selectedCategory &&
                    listings[i]['listingProvince'] == provinceValue) {
                  byFilter.add(listings[i]);
                }
              }
            }
            //filter by Category , Province & city Only
            else if (selectedCategory != 'None' &&
                provinceValue != null &&
                cityValue != null) {
              for (int i = 0; i < listings.length; i++) {
                if (listings[i]['category'] == selectedCategory &&
                    listings[i]['listingProvince'] == provinceValue &&
                    listings[i]['listingCity'] == cityValue) {
                  byFilter.add(listings[i]);
                }
              }
            }
            if (byFilter.length == 0) {
              return Scaffold(
                  body: Center(
                child: Text(
                  "Sorry, No Items To Display.",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                ),
              ));
            } else {
              return new Scaffold(
                  body: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      itemCount: byFilter.length,
                      itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.red,
                            elevation: 3.0,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                                              description: byFilter[index]
                                                  ['description'],
                                              listingProvince: byFilter[index]
                                                  ['listingProvince'],
                                              listingCity: byFilter[index]
                                                  ['listingCity'],
                                              itemName: byFilter[index]
                                                  ['itemName'],
                                              productImage: byFilter[index]
                                                  ['imageURL'],
                                              subCategories: byFilter[index]
                                                  ['subCategories'],
                                              timeStamp: byFilter[index]
                                                  ['listingTime'],
                                            )));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        15), // Image border
                                    child: AspectRatio(
                                      aspectRatio: 15 / 9,
                                      child: Image.network(
                                        byFilter[index]['imageURL'],
                                        fit: BoxFit.fill, // use this
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        byFilter[index]['itemName'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(byFilter[index]['category']),
                                      Text(byFilter[index]['listingTime']) 
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ))));
            }
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

  Widget filterDrawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.all(50),
        children: <Widget>[
          Text(
            "Select Filter Below:",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 50,
          ),
          ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.red,
              ),
              title: Text("Category",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
              onTap: () {}),
          SizedBox(
            height: 20,
          ),
          DropdownButton(
            // Initial Value
            value: selectedCategory,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: categoryList.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
          ),
          SizedBox(
            height: 150,
          ),
          ListTile(
            leading: Icon(Icons.place, color: Colors.red),
            title: Text("Location",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                height: 600,
                child: Column(
                  children: [
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.ENABLE,

                      ///placeholders for dropdown search field
                      stateSearchPlaceholder: 'Province',
                      citySearchPlaceholder: 'City',

                      ///labels for dropdown
                      stateDropdownLabel: "Province",
                      cityDropdownLabel: "City",

                      ///Default Country
                      defaultCountry: DefaultCountry.South_Africa,

                      ///Disable country dropdown (Note: use it with default country)
                      disableCountry: true,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (String? value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (String? value) {
                        setState(() {
                          ///store value in state variable
                          provinceValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (String? value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
