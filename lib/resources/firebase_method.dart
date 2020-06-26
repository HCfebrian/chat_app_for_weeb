import 'dart:io';

import 'package:chatappforweeb/constant/string.dart';
import 'package:chatappforweeb/model/message.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/provider/image_upload_provider.dart';
import 'package:chatappforweeb/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  StorageReference _storageReference;
  static final CollectionReference _userCollection =
      firestore.collection(USER_COLLECTION);

  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);

    AuthResult _authResult = await _auth.signInWithCredential(credential);

    return _authResult.user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot snapshot = await firestore
        .collection(USER_COLLECTION)
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = snapshot.documents;
    return docs.length == 0 ? true : false;
  }

  Future<void> addUserToDB(FirebaseUser firebaseUser) async {
    String username = Utils.getUsername(firebaseUser.email);

    user = User(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName,
      profilePhoto: firebaseUser.photoUrl,
      username: username,
    );

    firestore
        .collection(USER_COLLECTION)
        .document(firebaseUser.uid)
        .setData(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    print("logout");
    return _auth.signOut();
  }

  Future<List<User>> getAllUser(FirebaseUser user) async {
    QuerySnapshot snapshot =
        await firestore.collection(USER_COLLECTION).getDocuments();

    List<User> allUsers = [];
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        allUsers.add(User.fromMap(snapshot.documents[i].data));
      }
    }
    return allUsers;
  }

  Future<void> addMessageToDB(
      Message message, User sender, User receiver) async {
    var mapMessage = message.toMap();

    await firestore
        .collection(MESSAGE_COLLECTION)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(mapMessage);

    return await firestore
        .collection(MESSAGE_COLLECTION)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(mapMessage);
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);

      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return "error";
    }
  }

  void setImageMsg(String url, String receiverId, senderId) async {
    Message _message;

    _message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: "image");
    var map = _message.toImageMap();

    await firestore
        .collection(MESSAGE_COLLECTION)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await firestore
        .collection(MESSAGE_COLLECTION)
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();
    return User.fromMap(documentSnapshot.data);
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();

    String url = await uploadImageToStorage(image);

    imageUploadProvider.setToIdle();
    setImageMsg(url, receiverId, senderId);
  }
}
