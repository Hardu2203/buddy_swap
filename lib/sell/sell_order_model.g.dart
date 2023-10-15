// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellOrderModel _$SellOrderModelFromJson(Map<String, dynamic> json) =>
    SellOrderModel(
      (json['cryptoAmount'] as num).toDouble(),
      $enumDecode(_$CryptoTypeEnumMap, json['cryptoType']),
      (json['price'] as num).toDouble(),
      $enumDecode(_$FiatTypeEnumMap, json['fiatType']),
      $enumDecode(_$SellOrderStatusEnumMap, json['status']),
      json['owner'] as String,
    );

Map<String, dynamic> _$SellOrderModelToJson(SellOrderModel instance) =>
    <String, dynamic>{
      'cryptoAmount': instance.cryptoAmount,
      'cryptoType': _$CryptoTypeEnumMap[instance.cryptoType]!,
      'price': instance.price,
      'fiatType': _$FiatTypeEnumMap[instance.fiatType]!,
      'owner': instance.owner,
      'status': _$SellOrderStatusEnumMap[instance.status]!,
    };

const _$CryptoTypeEnumMap = {
  CryptoType.WETH: 'WETH',
  CryptoType.WBTC: 'WBTC',
};

const _$FiatTypeEnumMap = {
  FiatType.ZAR: 'ZAR',
  FiatType.USD: 'USD',
};

const _$SellOrderStatusEnumMap = {
  SellOrderStatus.CREATED: 'CREATED',
  SellOrderStatus.ALLOWANCE_CHECK_FAILED: 'ALLOWANCE_CHECK_FAILED',
  SellOrderStatus.TRANSFERING_FUNDS_TO_BUDDY_WALLET:
      'TRANSFERING_FUNDS_TO_BUDDY_WALLET',
  SellOrderStatus.ACTIVE: 'ACTIVE',
  SellOrderStatus.WAITING_BUYER_PAYMENT: 'WAITING_BUYER_PAYMENT',
  SellOrderStatus.COMPLETED: 'COMPLETED',
  SellOrderStatus.CANCELLED: 'CANCELLED',
};
