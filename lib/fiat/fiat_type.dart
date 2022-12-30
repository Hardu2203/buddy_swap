import 'package:buddy_swap/constants.dart';
import 'package:flutter/foundation.dart';

enum FiatType {
  zar,
  usd
}

extension FiatTypeExtension on FiatType {
  String get name => describeEnum(this);

  String get denominator {
    switch (this) {
      case FiatType.zar:
        return "R ";
      case FiatType.usd:
        return "\$ ";
    }
  }

  String get ticker {
    switch (this) {
      case FiatType.zar:
        return "ZAR";
      case FiatType.usd:
        return "USD";
    }
  }

  String get logo {
    switch (this) {
      case FiatType.zar:
        return kSouthAfricaFlagPath;
      case FiatType.usd:
        return kUnitedStatesOfAmericaFlagPath;
    }
  }

  String get displayName => "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}