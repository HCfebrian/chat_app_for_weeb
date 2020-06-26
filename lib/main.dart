import 'package:chatappforweeb/page/home_page.dart';
import 'package:chatappforweeb/page/login_page.dart';
import 'package:chatappforweeb/page/search_page.dart';
import 'package:chatappforweeb/provider/image_upload_provider.dart';
import 'package:chatappforweeb/provider/user_provider.dart';
import 'package:chatappforweeb/resources/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseRepository firebaseRepository = FirebaseRepository();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider(),),
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
      title: "WeebChat",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/search_page": (context) => SearchPage(),
      },
      theme: ThemeData(brightness: Brightness.dark),
      home: FutureBuilder(
        future: firebaseRepository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          return snapshot.hasData ? HomePage() : LoginPage();
        },
      ),
    ),);
  }
}
