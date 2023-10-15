// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['name'] as String,
      json['publicKey'] as String,
      json['privateKey'] as String?,
      json['jsonWebToken'] as String?,
      json['nonce'] as int?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'publicKey': instance.publicKey,
      'privateKey': instance.privateKey,
      'jsonWebToken': instance.jsonWebToken,
      'nonce': instance.nonce,
    };
