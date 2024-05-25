import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import '../src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_repo.dart';

class SharedPrefUserRepo implements UserRepository {
  final StreamController<MyUser?> _userController;

  SharedPrefUserRepo({StreamController<MyUser?>? userController})
      : _userController = userController ?? StreamController<MyUser?>();

  @override
  Stream<MyUser?> get user {
    return _userController.stream;
  }

  @override
  Future<void> signOut() async {
    _userController.add(null);
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      MyUser user = MyUser(email: myUser.email, password: password);
      await prefs.setString(myUser.email, json.encode(user));
      return myUser;
    } catch (e) {
      log(e.toString());
      throw UnimplementedError();
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      bool emailFound = await findEmail(email);
      if (emailFound) {
        bool passwordMatches = await findPassword(email, password);
        if (passwordMatches) {
          MyUser newUser = MyUser(password: password, email: email);
          _userController.add(newUser);
        } else {
          throw UnimplementedError("Password doesn't match");
        }
      } else {
        throw UnimplementedError("Email not found");
      }
    } catch (e) {
      log(
        e.toString(),
      );
      throw UnimplementedError();
    }
  }

  Future<bool> findEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tryFind = prefs.getString(email);
    return tryFind != null;
  }

  Future<bool> findPassword(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? tryFind = prefs.getString(email);
    MyUser myUser = MyUser.fromJson(
      json.decode(tryFind!),
    );

    if (password == myUser.password) {
      return true;
    } else {
      return false;
    }
  }
}
