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
  final Map<String, dynamic>? queryParams;

  BaseRequest(this.baseUrl, this.path, this.requestType,
      [this.mapping, this.json, this.headers, this.queryParams]);

  Future<T?> execute() async {
    Response response = await const RetryOptions(maxAttempts: 5).retry(
      () {
        var uri =
            Uri.parse(baseUrl + path).replace(queryParameters: queryParams);
        return (requestType == ReqType.get)
            ? requestType.method(uri, headers: headers)
            : requestType
                .method(
                  uri,
                  headers: headers,
                  body: jsonEncode(json),
                )
                .timeout(const Duration(seconds: 2));
      },
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    return mapping != null ? mapping!(jsonDecode(response.body)) : response.body as T?;
  }
}
