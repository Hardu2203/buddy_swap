import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) condition) {
    for (final element in this) {
      if (condition(element)) return element;
    }
    return null;
  }
}

Future<String> getContractId(int chainId, String id) async {
  String chainName = '';

  switch (chainId) {
    case 1:
      chainName = 'mainnet';
      break;
    case 137:
      chainName = 'matic';
      break;
    case 80001:
      chainName = 'mumbai';
      break;
    case 1337:
      chainName = 'local';
  }

  String contractId = '';
  String jsn = await rootBundle.loadString('JSON/$chainName.json');
  try {
    contractId = jsonDecode(jsn)[id];
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return '';
  }
  return contractId;
}

class Chain {
  final String networkName;
  final String rpcUrl;
  final String chainId;
  final String currencySymbol;
  final String blockExplorerUrl;

  Chain(this.networkName, this.rpcUrl, this.chainId, this.currencySymbol,
      this.blockExplorerUrl);
}
