class ChatRoomModel {
  String? chatroomid;
  List<String>? perticipent;
  ChatRoomModel({this.chatroomid, this.perticipent});
  ChatRoomModel.toFrom(Map<String, dynamic> map) {
    chatroomid = map['chatroomid'];
    perticipent = map['perticipent'];
  }
  Map<String, dynamic> toMap() {
    return {'chatroomid': chatroomid, "perticipent": perticipent};
  }
}
