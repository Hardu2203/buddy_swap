import 'package:buddy_swap/auth/login/jwt_model.dart';
import 'package:buddy_swap/environment_config.dart';
import 'package:flutter/foundation.dart';

import '../../auth/auth_provider.dart';
import '../../sell/sell_order_model.dart';
import '../../user/user_model.dart';
import '../base-request.dart';
import '../request-type.dart';

class BackendApi extends ChangeNotifier {

  final AuthProvider? _authProvider;
  final BackendApi? _previousBackendApi;


  BackendApi([this._authProvider, this._previousBackendApi]);

  assignUser() async {
    String publicKey = await _authProvider!.getPublicKey();
    UserModel? user = await getSingle("/user/$publicKey",
            (map) => UserModel("anon", publicKey, "", "", map["nonce"]));

    user?.jsonWebToken = await _authProvider?.getJwt();

    _authProvider?.loggedInUser = user;
  }

  Future<bool> login([UserModel? loggedInUser]) async {

    var isLoggedIn = await _authProvider?.isLoggedIn();
    if (isLoggedIn != null && isLoggedIn) {
      await assignUser();
      return true;
    }

    if (await _authProvider!.refreshTokenIsValid()) {
      return await loginWithRefreshToken();
    }

    return await loginFromScratch();
  }

  Future<bool> loginFromScratch() async {
    String publicKey = await _authProvider!.getPublicKey();
    UserModel? user = await getSingle("/user/$publicKey",
        (map) => UserModel("anon", publicKey, "", "", map["nonce"]));

    String? signedNonce = await _authProvider?.signMessage(
        "Sign this nonce to continue to sign in: ${user!.nonce!.toString()}");

    JwtModel? jwtModel = await post("/user/$publicKey", (map) => JwtModel.fromJson(map), null, null,
        Map.of({"signedNonce": signedNonce}));

    user?.jsonWebToken = jwtModel!.jwt;
    _authProvider?.loggedInUser = user;

    _authProvider?.storeJwtModel(jwtModel!);

    return user?.jsonWebToken != null;
  }

  Future<bool> loginWithRefreshToken() async {
    // ${await _authProvider?.getRefreshToken()}
    String jwt = await post("$kUser/login-with-refresh-token", null, "${await _authProvider?.getRefreshToken()}", Map.of({'Content-Type': 'application/json'}), null);
    await _authProvider?.storeJwt(jwt);
    await assignUser();

    return true;
  }

  void logout() {
    _authProvider?.loggedInUser = null;
  }

  Future<List<SellOrderModel>> getUserSellOrders() {
    return getList(
        kSellOrder,
        (map) => map.map((e) => SellOrderModel.fromJson(e as Map<String, dynamic>)).toList(),
        {"Authorization": "Bearer ${_authProvider?.loggedInUser?.jsonWebToken}"}
    ).then((result) => result ?? []);
  }

  Future<T?> getSingle<T>(String path,
      [T Function(Map<String, dynamic>)? mapping,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParams]) async {
    return await BaseRequest<T, Map<String, dynamic>>(
            EnvironmentConfig.backendApiUrl,
            path,
            ReqType.get,
            mapping,
            null,
            headers,
            queryParams)
        .execute();
  }

  Future<T?> getList<T>(String path,
      [T Function(List<dynamic>)? mapping,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParams]) async {
    return await BaseRequest<T, List<dynamic>>(
            EnvironmentConfig.backendApiUrl,
            path,
            ReqType.get,
            mapping,
            null,
            headers,
            queryParams)
        .execute();
  }

  Future<T?> post<T>(String path,
      [T Function(Map<String, dynamic>)? mapping,
      Object? json,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParams]) async {
    return await BaseRequest<T, Map<String, dynamic>>(
            EnvironmentConfig.backendApiUrl,
            path,
            ReqType.post,
            mapping,
            json,
            headers,
            queryParams)
        .execute();
  }

  static const String kUser = "/user";
  static const String kBank = "/bank";
  static const String kSellOrder = "/sell-order";


}
