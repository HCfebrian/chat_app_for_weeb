class Call {
  String callerId;
  String callerName;
  String callerPic;
  String receiverName;
  String receiverId;
  String receiverPic;
  String channelID;
  bool hasDialled;

  Call({this.callerId, this.callerName, this.callerPic, this.receiverName,
      this.receiverId, this.receiverPic, this.channelID, this.hasDialled});

  Map<String, dynamic> tomap(Call call){
    Map<String, dynamic> callMap = Map();
    callMap["callerId"] = call.callerId;
    callMap["callerName"] = call.callerName;
    callMap["callerPic"] = call.callerPic;
    callMap["receiverName"] = call.receiverName;
    callMap["receiverId"] = call.receiverId;
    callMap["receiverPic"] = call.receiverPic;
    callMap["channelID"] = call.channelID;
    callMap["hasDialled"] = call.hasDialled;
  return callMap;
  }

  Call.fromMap(Map callMap){
    this.callerId= callMap["callerId"];
    this.callerName= callMap["callerName"];
    this.callerPic= callMap["callerPic"]  ;
    this.receiverName= callMap["receiverName"];
    this.receiverId= callMap["receiverId"] ;
    this.receiverPic= callMap["receiverPic"] ;
    this.channelID= callMap["channelID"] ;
    this.hasDialled= callMap["hasDialled"] ;
  }
}
