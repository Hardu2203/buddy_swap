

import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/material.dart';

import '../api/backend/backend-api.dart';

class AuthProvider extends ChangeNotifier {

  UserModel? loggedInUser;
  AuthFunctions authFunctions;

  AuthProvider(this.authFunctions);

  Future<String> getPublicKey([UserModel? user]) async {
    return (await authFunctions.getPublicKey(user)).publicKey;
  }

  Future<String?> sendTransaction() async {
    return await authFunctions.sendTransaction();
  }

  void logout() {
    loggedInUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return loggedInUser != null;
  }

  Future<String> signMessage(String nonce) async {
    return await authFunctions.signMessage(nonce);
  }

}