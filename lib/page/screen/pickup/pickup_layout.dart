import 'package:chatappforweeb/model/call.dart';
import 'package:chatappforweeb/page/screen/pickup/pickup_screen.dart';
import 'package:chatappforweeb/provider/user_provider.dart';
import 'package:chatappforweeb/resources/call_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatefulWidget {
  final Widget scaffold;

  PickupLayout({this.scaffold});

  @override
  _PickupLayoutState createState() => _PickupLayoutState();
}

class _PickupLayoutState extends State<PickupLayout> {
  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context, snapshot) {
              print("auto isi dari  snapshot has data? ${(snapshot.hasData).toString()}");
              print("auto isi dari  snapshot.data.data null? ${(snapshot.data==null).toString()}");
              if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);
                if(!call.hasDialled){
                  return PickUpScreen(call: call);
                }else{
                  return widget.scaffold;
                }
              }
              return widget.scaffold;

            },
          )
        : Scaffold(
            body: Center(
              child: Column(
                children: <Widget>[
                RaisedButton(child: Text("hello there"),
                  onPressed: (){
                    print(" isi dari user provider null? ${(userProvider==null).toString()}");
                    print(" isi dari user provider get user null? ${(userProvider.getUser==null).toString()}");
                  },
                ), CircularProgressIndicator(),],
              ),
            ),
          );
  }
}

class Check extends StatelessWidget {
  DocumentSnapshot documentSnapshot;


  Check(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    print("auto isi dari document snapshot null? ${(documentSnapshot.data==null).toString()}");

    return Container();
  }
}
