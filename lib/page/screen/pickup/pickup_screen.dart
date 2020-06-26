

import 'package:chatappforweeb/model/call.dart';
import 'package:chatappforweeb/page/screen/call_screen.dart';
import 'package:chatappforweeb/resources/call_method.dart';
import 'package:flutter/material.dart';

class PickUpScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickUpScreen({ @required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            Image.network(
              call.callerPic,
              height: 150,
              width: 150,
            ),
            SizedBox(height: 15,),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                ),
                SizedBox(width: 25,),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CallScreen(call: call)
                  )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}