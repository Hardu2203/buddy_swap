import 'package:buddy_swap/api/base-request.dart';

import '../../environment_config.dart';
import '../request-type.dart';

class CoinApi {

  final String _baseUrl = "https://rest.coinapi.io/v1/exchangerate";
  final _headers = {
    'X-CoinAPI-Key': EnvironmentConfig.coinApiKey
  };

  static final CoinApi api =  CoinApi._internal(); //Only instance of the class

  ///Factory constructor to return instance;
  factory CoinApi() {
    return api;
  }

  CoinApi._internal(); //Private constructor

  Future<T?> getData<T>(String path, [ T Function(Map<String, dynamic>)? mapping, Object? json, Map<String, String>? headers ]) async {
    if (headers != null) {
      _headers.addAll(headers);
    }
    return await BaseRequest<T>(_baseUrl, path,  ReqType.get, mapping, json, _headers).execute();
  }

}