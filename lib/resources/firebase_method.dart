import 'package:chatappforweeb/model/message.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore firestore = Firestore.instance;
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
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = snapshot.documents;
    print(
        "hasil dari authuser ${(docs.length == 0 ? true : false).toString()}");
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
        .collection("users")
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
    QuerySnapshot snapshot = await firestore.collection("users").getDocuments();

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
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(mapMessage);

    return await firestore
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(mapMessage);
  }
}
