import 'dart:ffi';

class MessageModel {
  String? msgid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createon;

  MessageModel({this.sender, this.createon, this.seen, this.text, this.msgid});
  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createon = map['createon'].toDate();
    msgid = map['msgid'];
  }
  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "seen": seen,
      "text": text,
      "createon": createon,
      "msgid": msgid
    };
  }
}
