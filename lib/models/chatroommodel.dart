class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? perticipent;
  String? lastmsg;
  ChatRoomModel({this.chatroomid, this.perticipent, this.lastmsg});
  ChatRoomModel.toFrom(Map<String, dynamic> map) {
    chatroomid = map['chatroomid'];
    perticipent = map['perticipent'];
    lastmsg = map['lastmsg'];
  }
  Map<String, dynamic> toMap() {
    return {
      'chatroomid': chatroomid,
      "perticipent": perticipent,
      "lasrmsg": lastmsg
    };
  }
}
