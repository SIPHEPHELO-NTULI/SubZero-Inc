import 'package:flutter/material.dart';
import 'package:swap_shop/screens/create_listing.dart';
import 'package:swap_shop/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int curr = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curr,
        onTap: (index) {
          setState(() {
            curr = index;
            if (curr == 1) {
              print("hello");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CreateScreen()));
            }
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'HomeScreen',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Create',
              backgroundColor: Colors.red),
        ],
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: const Text("HomeScreen"),
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
