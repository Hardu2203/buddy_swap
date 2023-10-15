import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../environment_config.dart';

class DevAuthFunctions implements AuthFunctions {
  @override
  Future<UserModel> getPublicKey([UserModel? user]) async {
    return user!;
  }

  @override
  Future<String?> sendTransaction(ContractEnum contract, String functionName ,List<dynamic> parameters) {
    // TODO: implement sendTransaction
    throw UnimplementedError();
  }

  @override
  signMessage(String nonce) {
    // TODO: implement signMessage
    throw UnimplementedError();
  }

  @override
  Future<Widget> initializeWeb3(BuildContext context) {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  bool isWeb3Connected() {
    // TODO: implement isConnected
    throw UnimplementedError();
  }

  @override
  connectHandler(BuildContext context) {
    // TODO: implement connectHandler
    throw UnimplementedError();
  }

  @override
  logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
