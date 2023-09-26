import 'package:buddy_swap/crypto/crypto_types.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:buddy_swap/sell/sell_order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';

import '../auth/auth_provider.dart';
import '../constants.dart';
import '../environment_config.dart';

class SellProvider extends ChangeNotifier {
  SellProvider? _previousSellProvider;

  final AuthProvider? _authProvider;

  final List<SellOrderModel> _sellOrders = [
    SellOrderModel(0.1, CryptoType.bitcoin, 5000, FiatType.zar, SellOrderStatus.open, "0x339F31Df86D58BdbA677784da1c9a970Ec42B1b8")
  ];
  List<SellOrderModel> get sellOrders => _sellOrders;

  SellProvider([ this._authProvider, this._previousSellProvider]);
  
  void loadSellOrders() {
    // _sellOrders = [
    //   SellOrderModel(0.1, CryptoType.bitcoin, 5000, FiatType.zar, SellOrderStatus.open, "0x339F31Df86D58BdbA677784da1c9a970Ec42B1b8")
    // ];
    // notifyListeners();
  }


  Future<void> createSellOrder(double amount, CryptoType selectedCryptoType, double price, FiatType selectedFiatType) async {
    // if (_authProvider?.loggedInUser?.publicKey == null) {
    //   throw Exception("No logged in user");
    // }
    // _authProvider.sendTransaction()

    String? res = await _authProvider?.sendTransaction(ContractEnum.wbtc, "approve", [EthereumAddress.fromHex(kEnv.contractAddress.bank), BigInt.from(72)]);

    String? res2 = await _authProvider?.sendTransaction(ContractEnum.bank, "deposit", [EthereumAddress.fromHex(kEnv.contractAddress.wbtc), BigInt.from(2), BigInt.from(42) ]);
    // String? res2 = await _authProvider?.sendTransaction(ContractEnum.bank, "getContractBalance", [EthereumAddress.fromHex(kEnv.contractAddress.wbtc) ]);

    print('cool');
    // String loggedInUser = 'hardu'; //_authProvider!.loggedInUser!.publicKey;
    // _sellOrders.add(SellOrderModel(amount, selectedCryptoType, price, selectedFiatType, SellOrderStatus.open, loggedInUser));
    // notifyListeners();
  }

  void deleteSellOrder(int index) {
    _sellOrders.removeAt(index);
    notifyListeners();
  }

}