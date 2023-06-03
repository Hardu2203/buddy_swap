

import 'package:buddy_swap/constants.dart';
import 'package:flutter/foundation.dart';

import '../../auth/auth_provider.dart';
import '../../user/user_model.dart';
import '../base-request.dart';
import '../request-type.dart';

class BackendApi extends ChangeNotifier {

  // static final BackendApi api = BackendApi._internal(); //Only instance of the class
  // final Map<String, String>? _headers = null;
  // ///Factory constructor to return instance;
  // factory BackendApi() {
  //   return api;
  // }
  //
  // BackendApi._internal(); //Private constructor

  final AuthProvider? _authProvider;
  final BackendApi? _previousBackendApi;

  BackendApi([this._authProvider, this._previousBackendApi]);
  
  Future<bool> login([UserModel? loggedInUser]) async {
    String publicKey = await _authProvider!.getPublicKey();
    UserModel? user =   await getData( "/user/$publicKey",
            (map) => UserModel("anon", publicKey, "", "", map["nonce"]));

    String? signedNonce = await _authProvider?.signMessage("Sign this nonce to continue to sign in: ${user!.nonce!.toString()}");

    user?.jsonWebToken = await post( "/user/$publicKey",
            null, null, null, Map.of({ "signedNonce": signedNonce }));

    _authProvider?.loggedInUser = user;

    return user?.jsonWebToken != null;
  }

  Future<T?> getData<T>(String path, [ T Function(Map<String, dynamic>)? mapping, Object? json, Map<String, String>? headers, Map<String, dynamic>? queryParams ]) async {



    return await BaseRequest<T>(kBackendApiUrl, path,  ReqType.get, mapping, json, headers, queryParams).execute();
  }

  Future<T?> post<T>(String path, [ T Function(Map<String, dynamic>)? mapping, Object? json, Map<String, String>? headers, Map<String, dynamic>? queryParams ]) async {
    return await BaseRequest<T>(kBackendApiUrl, path,  ReqType.post, mapping, json, headers, queryParams).execute();
  }
}