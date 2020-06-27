import 'dart:math';

import 'package:chatappforweeb/model/call.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/page/screen/call_screen.dart';
import 'package:chatappforweeb/resources/call_method.dart';
import 'package:chatappforweeb/utils/permission.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, contex}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelID: Random().nextInt(100).toString(),
    );
    bool callMode = await callMethods.makeCall(call: call);
    call.hasDialled = true;
    if (callMode) {
      await Permissions.getPermission();
      await Navigator.push(
          contex,
          MaterialPageRoute(
              builder: (contex) => CallScreen(
                    call: call,
                  )));
    }
  }
}
