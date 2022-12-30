import 'package:buddy_swap/constants.dart';
import 'package:flutter/foundation.dart';

enum CryptoType {
  ethereum,
  bitcoin
}

extension FiatTypeExtension on CryptoType {
  String get name => describeEnum(this);

  String get logo {
    switch (this) {
      case CryptoType.bitcoin:
        return kBitcoinLogoPath;
      case CryptoType.ethereum:
        return kEthereumLogoPath;
    }
  }

  String get ticker {
    switch (this) {
      case CryptoType.bitcoin:
        return "BTC";
      case CryptoType.ethereum:
        return "ETH";
    }
  }

  String get displayName => "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}