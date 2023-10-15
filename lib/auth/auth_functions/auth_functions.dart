import 'dart:ffi';

import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/cupertino.dart';

import '../../environment_config.dart';

class AuthFunctions {
  Future<UserModel> getPublicKey([UserModel? user]) async {
    throw Exception("break");
  }

  Future<String?> sendTransaction(ContractEnum contract, String functionName,
      List<dynamic> parameters) async {
    throw Exception("break");
  }

  signMessage(String nonce) async {
    throw Exception("break");
  }

  Future<Widget> initializeWeb3(BuildContext context) async {
    throw Exception("break");
  }

  bool isWeb3Connected() {
    throw Exception("break");
  }

  logout() {
    throw Exception("break");
  }
}
