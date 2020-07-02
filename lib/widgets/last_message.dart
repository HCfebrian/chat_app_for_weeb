import 'package:chatappforweeb/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;

  const LastMessageContainer({Key key, @required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var doclist = snapshot.data.documents;

          if (doclist.isNotEmpty) {
            Message message = Message.fromMap(doclist.last.data);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                message.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            );
          }
          return Text(
            "No Message",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          );
        }
        return Text(
          "..",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        );
      },
    );
  }
}
