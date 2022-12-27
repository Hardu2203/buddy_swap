import 'package:buddy_swap/auth/auth_provider.dart';
import 'package:flutter/cupertino.dart';

class BuyProvider extends ChangeNotifier {

  BuyProvider? _previousBuyProvider;

  AuthProvider? _authProvider;

  BuyProvider([ this._authProvider, this._previousBuyProvider]);
}