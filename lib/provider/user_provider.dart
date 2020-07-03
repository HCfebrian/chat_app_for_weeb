import 'package:chatappforweeb/enum/user_state.dart';
import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/resources/auth_methods.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User _user;
  AuthMethods _authMethods = AuthMethods();


  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
   print("uid user apakah masih null?" + user.uid);
    _user = user;
    notifyListeners();
     }
}
