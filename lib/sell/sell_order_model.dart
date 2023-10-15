import 'package:buddy_swap/crypto/crypto_types.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sell_order_model.g.dart';

@JsonSerializable()
class SellOrderModel {

  double cryptoAmount = 0.0;
  CryptoType cryptoType = CryptoType.WETH;
  double price = 0.0;
  FiatType fiatType = FiatType.ZAR;
  String owner;

  SellOrderStatus status = SellOrderStatus.ACTIVE;

  SellOrderModel(this.cryptoAmount, this.cryptoType, this.price, this.fiatType,
      this.status, this.owner);

  String get priceString => fiatType.denominator + price.toString();

  String get cryptoAmountString => "$cryptoAmount ${cryptoType.ticker}";

  String get statusDisplayName => status.displayName;

  factory SellOrderModel.fromJson(Map<String, dynamic> json) => _$SellOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellOrderModelToJson(this);
}

enum SellOrderStatus {
  CREATED,
  ALLOWANCE_CHECK_FAILED,
  TRANSFERING_FUNDS_TO_BUDDY_WALLET,
  ACTIVE,
  WAITING_BUYER_PAYMENT,
  COMPLETED,
  CANCELLED,
}

extension SellOrderStatusExtension on SellOrderStatus {
  String get name => describeEnum(this);

  String get displayName => "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
}
