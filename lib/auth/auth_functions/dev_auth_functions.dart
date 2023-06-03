import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/user/user_model.dart';

class DevAuthFunctions implements AuthFunctions {
  @override
  Future<UserModel> getPublicKey([UserModel? user]) async {
    return user!;
  }

  @override
  Future<String?> sendTransaction() {
    // TODO: implement sendTransaction
    throw UnimplementedError();
  }

  @override
  signMessage(String nonce) {
    // TODO: implement signMessage
    throw UnimplementedError();
  }
}