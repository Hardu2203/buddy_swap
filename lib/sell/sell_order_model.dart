import 'package:buddy_swap/crypto/crypto_types.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

class SellOrderModel {
  Decimal cryptoAmount = Decimal.zero;
  CryptoType cryptoType = CryptoType.ethereum;
  Decimal price = Decimal.zero;
  FiatType fiatType = FiatType.zar;
  String owner;

  SellOrderStatus status = SellOrderStatus.open;

  SellOrderModel(this.cryptoAmount, this.cryptoType, this.price, this.fiatType,
      this.status, this.owner);

  String get priceString => fiatType.denominator + price.toString();

  String get cryptoAmountString => "$cryptoAmount ${cryptoType.ticker}";

  String get statusDisplayName => status.displayName;
}

enum SellOrderStatus { open, settled, cancelled }

extension SellOrderStatusExtension on SellOrderStatus {
  String get name => describeEnum(this);
  
  String get displayName => "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}
