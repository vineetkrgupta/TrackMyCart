import 'package:flutter/widgets.dart';
import 'package:tmcmerchant/models/merchant.dart';
import 'package:tmcmerchant/resources/auth_methods.dart';

class MerchantProvider with ChangeNotifier {
  Merchant? _merchant;
  final AuthMethods _authMethods = AuthMethods();

  Merchant get getMerchant => _merchant!;

  Future<void> refreshUser() async {
    Merchant user = await _authMethods.getMerchantDetails();
    _merchant = user;
    notifyListeners();
  }
}
