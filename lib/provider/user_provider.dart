import 'package:chatappforweeb/model/user.dart';
import 'package:chatappforweeb/resources/firebase_repository.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User _user;
  FirebaseRepository _repository = FirebaseRepository();

  User get getUser => _user;

  void refreshUser() async {
    User user = await _repository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
