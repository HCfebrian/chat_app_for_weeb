import 'package:chatappforweeb/model/contact.dart';
import 'package:chatappforweeb/page/screen/widget/contact_view.dart';
import 'package:chatappforweeb/page/screen/widget/new_chat_button.dart';
import 'package:chatappforweeb/page/screen/widget/quitebox.dart';
import 'package:chatappforweeb/page/screen/widget/user_circle.dart';
import 'package:chatappforweeb/provider/user_provider.dart';
import 'package:chatappforweeb/resources/chat_methods.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:chatappforweeb/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

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
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(userId: userProvider.getUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;
              if (docList.isEmpty) {
                return QuiteBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);
                  return ContactView(contact: contact);
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
