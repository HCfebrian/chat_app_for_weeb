import 'package:chatappforweeb/constant/string.dart';
import 'package:chatappforweeb/model/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      Firestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) {
    return callCollection.document(uid).snapshots();
  }

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialedMap = call.tomap(call);
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialedMap = call.tomap(call);

      await callCollection.document(call.callerId).setData(hasDialedMap);
      await callCollection.document(call.receiverId).setData(hasNotDialedMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.document(call.callerId).delete();
      await callCollection.document(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
