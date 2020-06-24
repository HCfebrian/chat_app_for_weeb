import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;

  Message(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});

  Message.imageMessage(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map["senderId"] = this.senderId;
    map["receiverId"] = this.receiverId;
    map["type"] = this.type;
    map["message"] = this.message;
    map["timestamp"] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map["senderId"] = this.senderId;
    map["receiverId"] = this.receiverId;
    map["type"] = this.type;
    map["message"] = this.message;
    map["timestamp"] = this.timestamp;
    map["photoUrl"] = this.photoUrl;

    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {

    this.senderId = map["senderId"];
    this.message = map["message"];
    this.receiverId = map["receiverId"];
    this.timestamp = map["timestamp"];
    this.type = map["type"];
    this.photoUrl = map["photoUrl"];

  }
}
