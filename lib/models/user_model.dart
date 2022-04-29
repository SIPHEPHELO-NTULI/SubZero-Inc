//this class hold the users registration details
// this makes it easier to track individual details of the user
class UserModel {
  String? uid;
  String? name;
  String? surname;
  String? username;
  String? email;
  String? province;
  String? city;

  UserModel(
      {this.uid,
      this.name,
      this.surname,
      this.username,
      this.email,
      this.province,
      this.city});

  //get data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      surname: map['surname'],
      username: map['username'],
      email: map['email'],
      province: map['province'],
      city: map['city'],
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'username': username,
      'email': email,
      'province': province,
      'city': city,
    };
  }
}
