import 'dart:convert';
import 'package:flutter/services.dart';


class ContractAddress {
  late String path;
  late String wbtc;
  late String weth;
  late String bank;
  late bool initialized = false;

  static ContractAddress? _instance;

  factory ContractAddress(String path) {
    _instance ??= ContractAddress._fromJson(path);
    return _instance!;
  }

  ContractAddress._fromJson(String path) {
    this.path = path;
  }

  Future<ContractAddress?> initialize() async {
    if (_instance?.initialized ?? false) {
      return _instance;
    }

    String abi = await rootBundle.loadString(
      "assets/smart-contracts/abi/ERC20.abi",
    );
    final jsonString = await rootBundle.loadString(path);
    final jsonMap = json.decode(jsonString);
    _instance?.wbtc = jsonMap['wbtc'];
    _instance?.weth = jsonMap['weth'];
    _instance?.bank = jsonMap['bank'];
    _instance?.initialized = true;
    return _instance;
  }
}



