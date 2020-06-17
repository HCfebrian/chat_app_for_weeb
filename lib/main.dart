import 'package:chatappforweeb/page/HomePage.dart';
import 'package:chatappforweeb/page/LoginPage.dart';
import 'package:chatappforweeb/resorces/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseRepository firebaseRepository = FirebaseRepository();
    return MaterialApp(
      title: "WeebChat",
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: firebaseRepository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser>snapshot){
          return snapshot.hasData?  HomePage() :  LoginPage();
        },

      ),
    );
  }
}
