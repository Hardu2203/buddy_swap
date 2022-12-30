import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum ReqType { get, post, put, delete }

extension ReqTypeExtension on ReqType {
  String get name => describeEnum(this);

  Function get method {
    switch (this) {
      case ReqType.get:
        return http.get;
      case ReqType.post:
        return http.post;
      case ReqType.put:
        return http.put;
      case ReqType.delete:
        return http.delete;
    }
  }
}
