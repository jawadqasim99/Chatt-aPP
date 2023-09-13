class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? perticipent;
  String? lastmsg;
  List<dynamic>? users;
  DateTime? createon;

  ChatRoomModel(
      {this.chatroomid,
      this.perticipent,
      this.lastmsg,
      this.createon,
      this.users});
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map['chatroomid'];
    perticipent = map['perticipent'];
    lastmsg = map['lastmsg'];
    users = map['users'];
    createon = map['createon'].toDate();
  }
  Map<String, dynamic> toMap() {
    return {
      'chatroomid': chatroomid,
      "perticipent": perticipent,
      "lastmsg": lastmsg,
      'users': users,
      "createon": createon
    };
  }
}
