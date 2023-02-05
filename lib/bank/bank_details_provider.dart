import 'package:buddy_swap/auth/auth_provider.dart';
import 'package:buddy_swap/bank/bank_details.dart';
import 'package:flutter/material.dart';

class BankDetailsProvider extends ChangeNotifier {

  BankDetails? _bankDetails;
  AuthProvider? _auth;
  bool _loaded = false;

  BankDetailsProvider([this._auth, previousBuyProvider]) {
    //load bank details from backend

    _loaded = true;
  }

  void setBankDetails(BankDetails bankDetails) {
    //send to backend



    //update listeners
    _bankDetails = bankDetails;
    notifyListeners();
  }

  bool isSet() {
    return _bankDetails != null && _loaded == true;
  }

}