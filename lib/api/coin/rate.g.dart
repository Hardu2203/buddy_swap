// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rate _$RateFromJson(Map<String, dynamic> json) => Rate(
      DateTime.parse(json['time'] as String),
      json['asset_id_base'] as String,
      json['asset_id_quote'] as String,
      (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$RateToJson(Rate instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'asset_id_base': instance.assetIdBase,
      'asset_id_quote': instance.assetIdQuote,
      'rate': instance.rate,
    };
