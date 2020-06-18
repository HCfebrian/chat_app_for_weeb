import 'package:chatappforweeb/model/message.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/resources/firebase_repository.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:chatappforweeb/widgets/appbar.dart';
import 'package:chatappforweeb/widgets/custom_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final User receiver;

  ChatPage({this.receiver});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController inputMessageController = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();
  bool isWriting = false;
  User sender;
  String _currentUserId;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((currentUser) {
      _currentUserId = currentUser.uid;

      setState(() {
        sender = User(
          uid: currentUser.uid,
          name: currentUser.displayName,
          profilePhoto: currentUser.photoUrl,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppbar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControl(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("messages")
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: snapshot['senderID'] == _currentUserId
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: snapshot['senderID'] == _currentUserId
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  getMessage(DocumentSnapshot documentSnapshot) {
    return Text(
      documentSnapshot["message"],
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot documentSnapshot) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius),
      ),
      child: Padding(
          padding: EdgeInsets.all(10), child: getMessage(documentSnapshot)),
    );
  }

  Widget receiverLayout(DocumentSnapshot documentSnapshot) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomRight: messageRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(documentSnapshot),
      ),
    );
  }

  Widget chatControl() {
    setWritingTo(bool bool) {
      setState(() {
        isWriting = bool;
      });
    }

    addMediaModule(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: (Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.close),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModelTile(
                        title: "Media",
                        subTitle: "Share Photo and Video",
                        icon: Icons.image,
                      ),
                      ModelTile(
                        title: "File",
                        subTitle: "Share Files",
                        icon: Icons.tab,
                      ),
                      ModelTile(
                        title: "Contact",
                        subTitle: "Share Contacts",
                        icon: Icons.contacts,
                      ),
                      ModelTile(
                        title: "Location",
                        subTitle: "Share Location",
                        icon: Icons.add_location,
                      ),
                      ModelTile(
                        title: "Schedule call",
                        subTitle: "Arrange Call and Get Remainder",
                        icon: Icons.schedule,
                      ),
                      ModelTile(
                        title: "Create Poll",
                        subTitle: "Share Poll",
                        icon: Icons.poll,
                      ),
                    ],
                  ),
                )
              ],
            );
          });
    }

    sendMessage() {
      var text = inputMessageController.text;

      Message message = Message(
          receiverId: widget.receiver.uid,
          senderId: sender.uid,
          message: text,
          timestamp: FieldValue.serverTimestamp(),
          type: 'text');

      setState(() {
        isWriting = false;
      });

      _repository.addMessageToDB(message, sender, widget.receiver);
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModule(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: inputMessageController,
              style: TextStyle(color: Colors.white),
              onChanged: (typingMassage) {
                (typingMassage.isNotEmpty && typingMassage.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: UniversalVariables.greyColor),
                  hintText: "Type a message",
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50),
                      ),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: UniversalVariables.separatorColor,
                  suffixIcon: GestureDetector(
                    child: Icon(
                      Icons.face,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  )),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting ? Container() : Icon(Icons.camera_alt),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  CustomAppbar customAppbar(BuildContext context) {
    return CustomAppbar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(widget.receiver.name),
      action: <Widget>[
        IconButton(
          icon: Icon(Icons.video_call),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.call),
          onPressed: () {},
        )
      ],
    );
  }
}

class ModelTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  const ModelTile({Key key, this.title, this.subTitle, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: UniversalVariables.receiverColor),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
