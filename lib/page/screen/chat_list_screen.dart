
import 'package:chatappforweeb/page/screen/widget/new_chat_button.dart';
import 'package:chatappforweeb/page/screen/widget/user_circle.dart';
import 'package:chatappforweeb/resources/auth_methods.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:chatappforweeb/widgets/appbar.dart';

import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final AuthMethods _authMethods = AuthMethods();
  String currentUserId;
  String initials = "";

  CustomAppbar customAppBar(BuildContext context) {

    return CustomAppbar(
      leading: IconButton(
        icon: Icon(Icons.notifications, color: Colors.white),
        onPressed: () {},
      ),
      title: UserCircle(),
      centerTitle: true,
      action: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_page");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: CustomChatButton(),
      body: ChatListContainer(),
    );
  }
}

class ChatListContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {

        },
      ),
    );
  }
}
