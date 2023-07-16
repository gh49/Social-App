import 'dart:ui';

class UserData {
  String uID;
  String email;
  String name;
  String phoneNumber;
  String image;
  String cover;
  String bio;


  UserData({
    required this.uID,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.cover,
    required this.bio,
});

  UserData.fromJson(Map<String, dynamic> json)
      : uID = json['uID'],
        email = json['email'],
        name = json['name'],
        phoneNumber = json['phoneNumber'],
        image = json['image'],
        cover = json['cover'],
        bio = json['bio'];

  Map<String, dynamic> toJson() => {
    'uID': uID,
    'email': email,
    'name': name,
    'phoneNumber': phoneNumber,
    'image': image,
    'cover': cover,
    'bio': bio,
  };

  @override
  String toString() {
    return "uID: $uID, email: $email, name: $name, phone number: $phoneNumber";
  }
}