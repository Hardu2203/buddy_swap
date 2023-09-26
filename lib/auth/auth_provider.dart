

import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/material.dart';

import '../api/backend/backend-api.dart';
import '../environment_config.dart';

class AuthProvider extends ChangeNotifier {

  UserModel? loggedInUser;
  AuthFunctions authFunctions;

  AuthProvider(this.authFunctions);

  Future<String> getPublicKey([UserModel? user]) async {
    return (await authFunctions.getPublicKey(user)).publicKey;
  }

  Future<String?> sendTransaction(ContractEnum contractEnum, String functionName, List<dynamic> parameters) async {
    return await authFunctions.sendTransaction(contractEnum, "0x47f7Aa90bBD05944c0553Cf36B39c539a95291b9", functionName ,parameters);
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