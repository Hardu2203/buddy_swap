import 'package:buddy_swap/user/user_model.dart';

import '../../environment_config.dart';

class AuthFunctions {

  Future<UserModel> getPublicKey([UserModel? user]) async {
    throw Exception("break");
  }

  Future<String?> sendTransaction(ContractEnum contract, String publicKey, String functionName ,List<dynamic> parameters) async {
    throw Exception("break");
  }

  signMessage(String nonce) async {
    throw Exception("break");
  }

}