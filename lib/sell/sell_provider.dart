import 'package:buddy_swap/crypto/crypto_types.dart';
import 'package:buddy_swap/fiat/fiat_type.dart';
import 'package:buddy_swap/sell/sell_order_model.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';

import '../auth/auth_provider.dart';

class SellProvider extends ChangeNotifier {
  SellProvider? _previousSellProvider;

  AuthProvider? _authProvider;

  List<SellOrderModel> _sellOrders = [];
  List<SellOrderModel> get sellOrders => _sellOrders;

  SellProvider([ this._authProvider, this._previousSellProvider]);
  
  void loadSellOrders() {
    _sellOrders = [
      SellOrderModel(Decimal.parse("0.1"), CryptoType.bitcoin, Decimal.fromInt(5000), FiatType.zar, SellOrderStatus.open, "0x339F31Df86D58BdbA677784da1c9a970Ec42B1b8")
    ];
    notifyListeners();
  }


  void createSellOrder() {
    _sellOrders.add(SellOrderModel(Decimal.parse("0.1"), CryptoType.ethereum, Decimal.fromInt(5000), FiatType.zar, SellOrderStatus.open, "0x339F31Df86D58BdbA677784da1c9a970Ec42B1b8"));
    notifyListeners();
  }

}