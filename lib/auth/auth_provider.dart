
import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  late UserModel _loggedInUser;
  AuthFunctions authFunctions;

  AuthProvider(this.authFunctions);

  void login([UserModel? user]) {
    _loggedInUser = authFunctions.login(user);
  }


}