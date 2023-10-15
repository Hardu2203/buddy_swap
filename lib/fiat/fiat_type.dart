import 'package:buddy_swap/constants.dart';
import 'package:flutter/foundation.dart';

enum FiatType {
  ZAR,
  USD
}

extension FiatTypeExtension on FiatType {
  String get name => describeEnum(this);

  String get denominator {
    switch (this) {
      case FiatType.ZAR:
        return "R ";
      case FiatType.USD:
        return "\$ ";
    }
  }

  String get ticker {
    switch (this) {
      case FiatType.ZAR:
        return "ZAR";
      case FiatType.USD:
        return "USD";
    }
  }

  String get logo {
    switch (this) {
      case FiatType.ZAR:
        return kSouthAfricaFlagPath;
      case FiatType.USD:
        return kUnitedStatesOfAmericaFlagPath;
    }
  }

  String get displayName => "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}
