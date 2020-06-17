import 'package:chatappforweeb/resorces/firebase_method.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  FirebaseMethod _firebaseMethod = FirebaseMethod();

  Future<FirebaseUser> getCurrentUser() => _firebaseMethod.getCurrentUser();

}
