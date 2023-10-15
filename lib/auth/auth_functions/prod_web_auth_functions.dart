



import 'package:flutter/src/widgets/framework.dart';

import '../../environment_config.dart';
import '../../user/user_model.dart';
import 'auth_functions.dart';
import  'js_stub.dart' if (dart.library.js) 'package:flutter_web3/flutter_web3.dart';



class ProdWebAuthFunctions implements AuthFunctions {

  @override
  Future<UserModel> getPublicKey([UserModel? user]) async {
    final accs = await ethereum!.requestAccount();

    return UserModel("anon", accs.first);
  }

  void transaction() async {
    // Send 1000000000 wei to `0xcorge`
    // final tx = await provider!.getSigner().sendTransaction(
    //   TransactionRequest(
    //     to: '0xcorge',
    //     value: BigInt.from(1000000000),
    //   ),
    // );
    //
    // tx.hash; // 0xplugh
    //
    // final receipt = await tx.wait();

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
  clearJwt() {
    // TODO: implement clearJwt
    throw UnimplementedError();
  }

  @override
  storeJwt(String jwt) {
    // TODO: implement storeJwt
    throw UnimplementedError();
  }

  @override
  bool isWeb3Connected() {
    // TODO: implement isConnected
    throw UnimplementedError();
  }

  @override
  initWeb3Handlers(BuildContext context) {
    // TODO: implement initWeb3Handlers
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
