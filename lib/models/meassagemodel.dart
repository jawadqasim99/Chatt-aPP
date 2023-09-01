import 'dart:ffi';

class MessageModel {
  String? sender;
  String? text;
  Bool? seen;
  DateTime? createon;

  MessageModel({this.sender, this.createon, this.seen, this.text});
  MessageModel.toFrom(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createon = map['createon'].toDate();
  }
  Map<String, dynamic> toMap() {
    return {"sender": sender, "seen": seen, "text": text, "createon": createon};
  }
}
