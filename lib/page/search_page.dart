import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/page/chat_page.dart';
import 'package:chatappforweeb/resources/firebase_repository.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:chatappforweeb/widgets/custom_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirebaseRepository _repository = FirebaseRepository();
  List<User> _listUser = [];

  String query = "";
  TextEditingController textEditingController = TextEditingController();
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser currentUser) {
      _repository.getAllUsers(currentUser).then((List<User> allUser) {
        setState(() {
          _listUser = allUser;
        });
      });
    });
  }

  Widget customSearchBar(BuildContext context) {
    return GradientAppBar(
      backgroundColorEnd: UniversalVariables.gradientColorStart,
      backgroundColorStart: UniversalVariables.gradientColorStart,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: textEditingController,
            onChanged: (text) {
              setState(() {
                query = text;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    textEditingController.clear();
                  },
                ),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0x88ffffff))),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : _listUser.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _getQuery = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool _matchUsername = _getUsername.contains(_getQuery);
            bool _matchName = _getUsername.contains(_getName);
            return (_matchName || _matchUsername);
          }).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context, index) {
          User searchedUser = User(
            uid: suggestionList[index].uid,
            name: suggestionList[index].name,
            username: suggestionList[index].username,
            profilePhoto: suggestionList[index].profilePhoto,
          );
          return CustomTile(
            mini: false,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.profilePhoto),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              searchedUser.username,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              searchedUser.name,
              style: TextStyle(color: UniversalVariables.greyColor),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(receiver: searchedUser,)));
            },
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customSearchBar(context),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: buildSuggestions(query)),
    );
  }
}
