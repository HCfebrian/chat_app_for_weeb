import 'package:chatappforweeb/constant/string.dart';
import 'package:chatappforweeb/model/contact.dart';
import 'package:chatappforweeb/model/message.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _messageCollections =
      _firestore.collection(MESSAGE_COLLECTION);
  final CollectionReference _userCollection =
      _firestore.collection(MESSAGE_COLLECTION);

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await _messageCollections
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollections
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocuments({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(CONTACT_COLLECTION)
          .document(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContact(senderId, receiverId, currentTime);
    await addToReceiverContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContact(
      String senderId, String receiverID, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocuments(of: senderId, forContact: receiverID).get();

    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverID,
        addOn: currentTime,
      );
      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocuments(of: senderId, forContact: receiverID)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContact(
      String senderId, String receiverID, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocuments(of: receiverID, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addOn: currentTime,
      );
      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocuments(of: receiverID, forContact: senderId)
          .setData(senderMap);
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollections
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    _messageCollections
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACT_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween(
          {@required String senderId, @required String receiverId}) =>
      _messageCollections
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
