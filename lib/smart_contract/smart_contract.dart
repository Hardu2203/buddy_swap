import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart' show rootBundle;

class SmartContract {
  static final Web3Client _smC =
  Web3Client('http://10.0.2.2:8545', Client()); //smC = Smart Contract
  // Web3Client('https://matic-mumbai.chainstacklabs.com', Client());

  late String conAbi;
  late String address;

  DeployedContract? _contract;
  bool _loaded = false;

  SmartContract(String ab, String name) {
    conAbi = ab;
    address = name;
  }

  Future<DeployedContract> _getContract() async {
    if (!_loaded) {
      String abi = await rootBundle.loadString(conAbi);

      _contract = DeployedContract(
          ContractAbi.fromJson(abi, "MessageVerifier"),
          EthereumAddress.fromHex("0xC93005DA9BE5a74102f6BFAa79E50A34D64c32A4"));

      _loaded = true;
    }

    return _contract!;
  }

  Future<List<dynamic>> makeReadCall(
      String function, List<dynamic> args) async {
    //Read from contract
    final theContract = await _getContract();
    final fun = theContract.function(function);
    List<dynamic> theResult =
    await _smC.call(contract: theContract, function: fun, params: args);

    return theResult;
  }
}
