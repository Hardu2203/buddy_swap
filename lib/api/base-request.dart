import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buddy_swap/api/request-type.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';

class BaseRequest<T> {

  final String baseUrl;
  final String path;
  final ReqType requestType;
  final T Function(Map<String, dynamic>)? mapping;
  final Object? json;
  final Map<String, String>? headers;

  BaseRequest(this.baseUrl, this.path, this.requestType, [ this.mapping, this.json,  this.headers ]);

  Future<T?> execute() async {
    Response response = await const RetryOptions(maxAttempts: 5).retry(
          () => (requestType == ReqType.get)
          ? requestType.method(Uri.parse(baseUrl + path), headers: headers)
          : requestType.method(
        Uri.parse(baseUrl + baseUrl),
        headers: headers,
        body: jsonEncode(json),
      ).timeout(const Duration(seconds: 2)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    return mapping != null ? mapping!(jsonDecode(response.body)) : null;
  }


  
}