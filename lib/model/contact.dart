import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  Timestamp addOn;

  Contact({this.uid, this.addOn});

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addOn;
    return data;
  }

  Contact.fromMap(Map<String,dynamic> mapData){
    this.uid = mapData["contact_id"];
    this.addOn = mapData["added_on"];
  }
}
