import 'package:buddy_swap/api/backend/backend-api.dart';
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
  final BackendApi? _backendApi;

  List<SellOrderModel> _sellOrders = [
    // SellOrderModel(0.1, CryptoType.WBTC, 5000, FiatType.ZAR, SellOrderStatus.ACTIVE, "0x339F31Df86D58BdbA677784da1c9a970Ec42B1b8")
  ];
  List<SellOrderModel> get sellOrders => _sellOrders;

  SellProvider([ this._authProvider, this._backendApi, this._previousSellProvider]);

  void loadSellOrders() async {
    _sellOrders = await _backendApi!.getUserSellOrders();
    notifyListeners();
  }


  Future<String?> createSellOrder(double amount, CryptoType selectedCryptoType, double price, FiatType selectedFiatType) async {
    // if (_authProvider?.loggedInUser?.publicKey == null) {
    //   throw Exception("No logged in user");
    // }
    // _authProvider.sendTransaction()

    String? approvedTx = await _authProvider?.sendTransaction(selectedCryptoType.contract, "approve", [EthereumAddress.fromHex(kEnv.contractAddress.bank), BigInt.from(amount)]);

    String? depositTx = await _authProvider?.sendTransaction(ContractEnum.bank, "deposit", [EthereumAddress.fromHex(EnvironmentConfig.getContractAddress(selectedCryptoType.contract)), BigInt.from(amount), BigInt.from(price) ]);
    // String? res2 = await _authProvider?.sendTransaction(ContractEnum.bank, "getContractBalance", [EthereumAddress.fromHex(kEnv.contractAddress.wbtc) ]);

    return depositTx;
    // String loggedInUser = 'hardu'; //_authProvider!.loggedInUser!.publicKey;
    // _sellOrders.add(SellOrderModel(amount, selectedCryptoType, price, selectedFiatType, SellOrderStatus.open, loggedInUser));
    // notifyListeners();
  }

  void deleteSellOrder(int index) {
    _sellOrders.removeAt(index);
    notifyListeners();
  }

}
