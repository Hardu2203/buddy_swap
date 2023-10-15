import 'package:buddy_swap/constants.dart';
import 'package:flutter/foundation.dart';

import '../environment_config.dart';

enum CryptoType {
  WETH(ContractEnum.weth),
  WBTC(ContractEnum.wbtc);

  final ContractEnum contract;

  const CryptoType(this.contract);
}

extension FiatTypeExtension on CryptoType {
  String get name => describeEnum(this);

  String get logo {
    switch (this) {
      case CryptoType.WBTC:
        return kBitcoinLogoPath;
      case CryptoType.WETH:
        return kEthereumLogoPath;
    }
  }

  String get ticker {
    switch (this) {
      case CryptoType.WBTC:
        return "BTC";
      case CryptoType.WETH:
        return "ETH";
    }
  }

  String get displayName => "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}
