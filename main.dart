import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
   const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  List<String> values =['assets/ps4.jpg','assets/download.jpg','assets/jacket.jpg','assets/phne.jpg','assets/pots.jpg','assets/shoe.jpg','assets/jacket.jpg','assets/phne.jpg','assets/pots.jpg','assets/shoe.jpg','assets/ps4.jpg','assets/download.jpg'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SWAPSHOP'),
          backgroundColor: Colors.red,
        ),
      body: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,

      ),
      itemCount: values.length,
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
                      Text("UserName",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("ItemName"),
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
}
