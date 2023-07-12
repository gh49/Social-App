class UserData {
  String uID;
  String email;
  String name;
  String phoneNumber;
  bool emailVerified;

  UserData({
    required this.uID,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.emailVerified,
});

  UserData.fromJson(Map<String, dynamic> json)
      : uID = json['uID'],
        email = json['email'],
        name = json['name'],
        phoneNumber = json['phoneNumber'],
        emailVerified = json['emailVerified'];

  Map<String, dynamic> toJson() => {
    'uID': uID,
    'email': email,
    'name': name,
    'phoneNumber': phoneNumber,
    'emailVerified': emailVerified,
  };

  @override
  String toString() {
    return "uID: $uID, email: $email, name: $name, phone number: $phoneNumber"
        ", Verification status: ${emailVerified ? 'Verified' : 'Not Verified'}";
  }
}