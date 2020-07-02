import 'package:chatappforweeb/enum/user_state.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/resources/auth_methods.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:chatappforweeb/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OnlineIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineIndicator({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _authMethods.getUserStream(uid: uid),
      builder: (context, snapshot) {
        User user;
        if (snapshot.hasData && snapshot.data.data != null) {
          user = User.fromMap(snapshot.data.data);
        }
        return Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColor(user?.state),
                border:
                    Border.all(color: UniversalVariables.blackColor, width: 2)),
          ),
        );
      },
    );
  }
}
