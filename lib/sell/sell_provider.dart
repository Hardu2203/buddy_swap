import 'package:flutter/cupertino.dart';

import '../auth/auth_provider.dart';

class SellProvider extends ChangeNotifier {
  SellProvider? _previousSellProvider;

  AuthProvider? _authProvider;

  SellProvider([ this._authProvider, this._previousSellProvider]);
}