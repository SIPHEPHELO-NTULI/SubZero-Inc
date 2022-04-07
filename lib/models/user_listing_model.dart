//this class hold the users listing details
// this makes it easier to track individual details of the listing
//such as the item name, the category and the description
// along with the imageURL of their item

class UserListingModel {
  String? uid;
  String? listingID;
  String? itemName;
  String? category;
  String? description;
  String? imageURL;

  UserListingModel(
      {this.uid,
      this.listingID,
      this.itemName,
      this.category,
      this.description,
      this.imageURL});

  //get data from server
  factory UserListingModel.fromMap(map) {
    return UserListingModel(
        uid: map['uid'],
        listingID: map['listingID'],
        itemName: map['itemName'],
        category: map['category'],
        description: map['description'],
        imageURL: map['imageURL']);
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'listingID': listingID,
      'itemName': itemName,
      'category': category,
      'description': description,
      'imageURL': imageURL
    };
  }
}
