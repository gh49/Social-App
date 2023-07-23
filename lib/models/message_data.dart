
class MessageData {
  String senderUID;
  String receiverUID;
  String dateTime;
  String text;


  MessageData({
    required this.senderUID,
    required this.receiverUID,
    required this.dateTime,
    required this.text,
  });

  MessageData.fromJson(Map<String, dynamic> json)
      : senderUID = json['senderUID'],
        receiverUID = json['receiverUID'],
        dateTime = json['dateTime'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
    'senderUID': senderUID,
    'receiverUID': receiverUID,
    'dateTime': dateTime,
    'text': text,
  };

  @override
  String toString() {
    return "senderUID: $senderUID, receiverUID: $receiverUID, dateTime: $dateTime, message: $text";
  }
}