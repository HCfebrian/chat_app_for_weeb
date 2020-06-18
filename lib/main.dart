import 'package:chatappforweeb/page/home_page.dart';
import 'package:chatappforweeb/page/login_page.dart';
import 'package:chatappforweeb/page/search_page.dart';
import 'package:chatappforweeb/resources/firebase_repository.dart';
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
      initialRoute: "/",
      routes:{
        "/search_page":(context) => SearchPage(),
      },
      home: FutureBuilder(
        future: firebaseRepository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          print(snapshot?.data?.displayName);
          return snapshot.hasData? HomePage() : LoginPage();
        },
      ),
    );
  }
}
