import 'package:chatappforweeb/model/contact.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/page/chat_page.dart';
import 'package:chatappforweeb/provider/user_provider.dart';
import 'package:chatappforweeb/resources/auth_methods.dart';
import 'package:chatappforweeb/resources/chat_methods.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:chatappforweeb/widgets/cached_image.dart';
import 'package:chatappforweeb/widgets/custom_tile.dart';
import 'package:chatappforweeb/widgets/last_message.dart';
import 'package:chatappforweeb/widgets/online_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      receiver: contact,
                    )));
      },
      title: Text(
        contact?.name ?? "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
          stream: _chatMethods.fetchLastMessageBetween(
              senderId: userProvider.getUser.uid, receiverId: contact.uid)),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineIndicator(uid: contact.uid,)
          ],
        ),
      ),
    );
  }
}
