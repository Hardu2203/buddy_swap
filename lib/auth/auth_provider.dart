import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/auth/login/jwt_model.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../environment_config.dart';
import 'login/jwt_storage.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? loggedInUser;
  AuthFunctions authFunctions;
  final JwtStorage jwtStorage = JwtStorage();
  final String JWT = "jwt";
  final String REFRESH_TOKEN = "refresh_token";
  Widget? _web3Widget;

  AuthProvider(this.authFunctions);

  Future<Widget> initializeWeb3(BuildContext context) async {
    _web3Widget = await authFunctions.initializeWeb3(context);
    return _web3Widget!;
  }

  Future<Widget> getWeb3Widget(BuildContext context) async {
    return _web3Widget!;
  }


  bool isWeb3Connected() {
    return authFunctions.isWeb3Connected();
  }

  bool web3Logout() {
    return authFunctions.logout();
  }

  Future<String> getPublicKey([UserModel? user]) async {
    return (await authFunctions.getPublicKey(user)).publicKey;
  }

  Future<String?> sendTransaction(ContractEnum contractEnum,
      String functionName, List<dynamic> parameters) async {
    return await authFunctions.sendTransaction(contractEnum, functionName, parameters);
  }

  Future<void> storeJwtModel(JwtModel jwtModel) async {
    await jwtStorage.write(JWT, jwtModel.jwt);
    await jwtStorage.write(REFRESH_TOKEN, jwtModel.refreshToken);
  }

  Future<void> storeJwt(String jwt) async {
    await jwtStorage.write(JWT, jwt);
  }

  void logout() {
    jwtStorage.deleteAll();
    authFunctions.logout();
    loggedInUser = null;
    notifyListeners();
  }

  Future<String?> getJwt() async {
    return await jwtStorage.read(JWT);
  }

  Future<String?> getRefreshToken() async {
    return await jwtStorage.read(REFRESH_TOKEN);
  }

  Future<bool> refreshTokenIsValid() async {
    var refreshToken = await getRefreshToken();
    if (refreshToken != null) {
      return tokenIsValid(refreshToken);
    } else {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {

    String? jwt = await jwtStorage.read(JWT);
    if (jwt == null || jwt.isEmpty) return false;
    if (!tokenIsValid(jwt)) return false;

    return true;
  }

  tokenIsValid(String token) {
    DateTime? expiryDate = Jwt.getExpiryDate(token);
    if (expiryDate == null) return false;
    if (DateTime.now().isAfter(expiryDate)) return false;

    return true;
  }

  Future<String> signMessage(String nonce) async {
    Future<dynamic> future  = authFunctions.signMessage(nonce);

    return await future;
  }
}
