

import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/material.dart';

import '../api/backend/backend-api.dart';

class AuthProvider extends ChangeNotifier {

  UserModel? _loggedInUser;
  AuthFunctions authFunctions;
  final BackendApi _backendApi = BackendApi();

  AuthProvider(this.authFunctions);

  void login([UserModel? user]) {
    _loggedInUser = authFunctions.login(user);
    _backendApi.
  }

  void logout() {
    _loggedInUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _loggedInUser != null;
  }

  UserModel? get loggedInUser => _loggedInUser;



}