import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser>getCurrentUser() async{
    return _auth.currentUser();
  }

}