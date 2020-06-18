import 'package:chatappforweeb/model/message.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/resources/firebase_method.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  FirebaseMethod _firebaseMethod = FirebaseMethod();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethod.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethod.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseMethod.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user) {
    return _firebaseMethod.addUserToDB(user);
  }

//  Future<void> signOut() => _firebaseMethod.signOut();

  Future<List<User>> getAllUsers(FirebaseUser user) =>
      _firebaseMethod.getAllUser(user);

  Future<void> addMessageToDB(Message message, User sender, User receiver) =>
      _firebaseMethod.addMessageToDB(message, sender, receiver);
}
