class UserData {
  String uID;
  String email;
  String name;
  String phoneNumber;

  UserData({
    required this.uID,
    required this.email,
    required this.name,
    required this.phoneNumber,
});

  UserData.fromJson(Map<String, dynamic> json)
      : uID = json['uID'],
        email = json['email'],
        name = json['name'],
        phoneNumber = json['phoneNumber'];

  Map<String, dynamic> toJson() => {
    'uID': uID,
    'email': email,
    'name': name,
    'phoneNumber': phoneNumber,
  };
}