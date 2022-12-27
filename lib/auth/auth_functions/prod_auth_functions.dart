import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/user/user_model.dart';

class ProdAuthFunctions implements AuthFunctions {
  @override
  UserModel login([UserModel? user]) {
    return user!;
  }

}