
class PostData {
  String uID;
  String name;
  String image;
  String dateTime;
  String text;
  String? postImage;


  PostData({
    required this.uID,
    required this.name,
    required this.image,
    required this.dateTime,
    required this.text,
    this.postImage
});

  PostData.fromJson(Map<String, dynamic> json)
      : uID = json['uID'],
        name = json['name'],
        image = json['image'],
        dateTime = json['dateTime'],
        text = json['text'],
        postImage = json['postImage'];

  Map<String, dynamic> toJson() => {
    'uID': uID,
    'name': name,
    'image': image,
    'dateTime': dateTime,
    'text': text,
    'postImage': postImage,
  };

  @override
  String toString() {
    return "uID: $uID, name: $name, text: $text";
  }
}