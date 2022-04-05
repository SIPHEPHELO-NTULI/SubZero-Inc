import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatefulWidget {
  //getting the userID

  String? userID;
  ShowImage({Key? key, this.userID}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Images")),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.userID)
              .collection("images")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return (const Center(child: Text("No Images Uploaded")));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String url = snapshot.data!.docs[index]['downloadURL'];
                    return Image.network(
                      url,
                      height: 300,
                      fit: BoxFit.cover,
                    );
                  });
            }
          }),
    );
  }
}
