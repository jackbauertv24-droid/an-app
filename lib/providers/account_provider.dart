import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../data/accounts.dart';

class AccountProvider extends ChangeNotifier {
  Account? _currentAccount;
  List<Account> get accounts => demoAccounts;
  Account? get currentAccount => _currentAccount;
  bool get hasSelectedAccount => _currentAccount != null;

  void selectAccount(Account account) {
    _currentAccount = account;
    notifyListeners();
  }

  void clearAccount() {
    _currentAccount = null;
    notifyListeners();
  }
}
