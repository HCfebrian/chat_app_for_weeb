import 'package:chatappforweeb/enum/user_state.dart';
import 'package:chatappforweeb/page/screen/chat_list_screen.dart';
import 'package:chatappforweeb/page/screen/pickup/pickup_layout.dart';
import 'package:chatappforweeb/provider/user_provider.dart';
import 'package:chatappforweeb/resources/auth_methods.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  UserProvider userProvider;
  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();

    });

    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("Inactive");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("pause state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _tabFontSize = 10;
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Center(child: Text("Call List Screen")),
            Center(child: Text("Contact Screen"))
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: (_page == 0)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Chat",
                    style: TextStyle(
                        fontSize: _tabFontSize,
                        color: (_page == 0)
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.phone,
                      color: (_page == 1)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _tabFontSize,
                        color: (_page == 1)
                            ? UniversalVariables.lightBlueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contacts,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: _tabFontSize,
                        color: (_page == 2)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
