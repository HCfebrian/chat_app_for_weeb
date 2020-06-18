import 'package:chatappforweeb/resources/firebase_method.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  FirebaseMethod _firebaseMethod = FirebaseMethod();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethod.getCurrentUser();

  Future<FirebaseUser> signIn() => _firebaseMethod.signIn();

  Future<bool> authenticateUser(FirebaseUser user) => _firebaseMethod.authenticateUser(user);

  Future<void> addDataToDb(FirebaseUser user)  {
    return _firebaseMethod.addUserToDB(user);
  }

  Future<void> signOut() => _firebaseMethod.signOut();

}