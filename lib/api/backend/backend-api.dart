

import 'package:buddy_swap/constants.dart';

import '../base-request.dart';
import '../request-type.dart';

class BackendApi {

  static final BackendApi api = BackendApi._internal(); //Only instance of the class
  final Map<String, String>? _headers = null;
  ///Factory constructor to return instance;
  factory BackendApi() {
    return api;
  }

  BackendApi._internal(); //Private constructor

  Future<T?> getData<T>(String path, [ T Function(Map<String, dynamic>)? mapping, Object? json, Map<String, String>? headers ]) async {
    return await BaseRequest<T>(kBackendApiUrl, path,  ReqType.get, mapping, json, _headers).execute();
  }

  Future<T?> post<T>(String path, [ T Function(Map<String, dynamic>)? mapping, Object? json, Map<String, String>? headers ]) async {
    return await BaseRequest<T>(kBackendApiUrl, path,  ReqType.get, mapping, json, _headers).execute();
  }
}